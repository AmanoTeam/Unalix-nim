import sugar
import tables
import net
import asyncnet
import asyncdispatch
import strutils
import json
import uri
import re
import os

import ./types
import ./exceptions
import ./rulesets
import ./utils

proc compileRulesets(rulesetsList: JsonNode): seq[TableRef[string, Node]] =
    ## Compile rulesets from a JsonNode object

    var rulesets = newSeq[TableRef[string, Node]]()

    var
        table: TableRef[string, Node]
        rules, referralMarketing, rawRules, exceptions, redirections: seq[Regex]

    for provider in rulesetsList:

        table = newTable[string, Node]()

        # This field is ignored by Unalix, we are leaving it here just for reference
        # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
        table["providerName"] = Node(kind: nkString, strVal: provider["providerName"].getStr())

        # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
        table["urlPattern"] = Node(kind: nkRegex, regexVal: rex(provider["urlPattern"].getStr()))

        # https://docs.clearurls.xyz/latest/specs/rules/#completeprovider
        table["completeProvider"] = Node(kind: nkBool, boolVal: provider["completeProvider"].getBool())

        # https://docs.clearurls.xyz/latest/specs/rules/#rules
        rules = block: collect newSeq: (for rule in provider["rules"]: rex("(%(?:26|23)|&|^)" & rule.getStr() & "(?:(?:=|%3[Dd])[^&]*)"))
        table["rules"] = Node(kind: nkSeqRegex, seqRegexVal: rules)

        # https://docs.clearurls.xyz/latest/specs/rules/#rawrules
        rawRules = block: collect newSeq: (for rawRule in provider["rawRules"]: rex(rawRule.getStr()))
        table["rawRules"] = Node(kind: nkSeqRegex, seqRegexVal: rawRules)

        # https://docs.clearurls.xyz/latest/specs/rules/#referralmarketing
        referralMarketing = block: collect newSeq: (for referral in provider["referralMarketing"]: rex("(%(?:26|23)|&|^)" & referral.getStr() & "(?:(?:=|%3[Dd])[^&]*)"))
        table["referralMarketing"] = Node(kind: nkSeqRegex, seqRegexVal: referralMarketing)

        # https://docs.clearurls.xyz/latest/specs/rules/#exceptions
        exceptions = block: collect newSeq: (for exception in provider["exceptions"]: rex(exception.getStr()))
        table["exceptions"] = Node(kind: nkSeqRegex, seqRegexVal: exceptions)

        # https://docs.clearurls.xyz/latest/specs/rules/#redirections
        redirections = block: collect newSeq: (for redirection in provider["redirections"]: rex(redirection.getStr() & ".*"))
        table["redirections"] = Node(kind: nkSeqRegex, seqRegexVal: redirections)

        # This field is ignored by Unalix, we are leaving it here just for reference
        # https://docs.clearurls.xyz/latest/specs/rules/#forceredirection
        table["forceRedirection"] = Node(kind: nkBool, boolVal: provider["forceRedirection"].getBool())

        rulesets.add(table)

    result = rulesets

var
    rulesetsTable {.threadvar.}: seq[TableRef[string, Node]]

rulesetsTable = compileRulesets(rulesetsNode)

proc clearUrl*(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false
): string =
    ##
    ##    This method implements the same specification used in the addon version of ClearURLs (with a few minor exceptions)
    ##    for removing tracking fields and unshortening URLs.
    ##
    ##    Parameters:
    ##
    ##        url (`string`):
    ##            A string representing an HTTP URL.
    ##
    ##        ignoreReferralMarketing (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not remove referral marketing fields from the URL query. Defaults to `false`.
    ##
    ##            This is similar to ClearURLs"s **"Allow referral marketing"** option.
    ##
    ##        ignoreRules (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not remove tracking fields from the given URL. Defaults to `false`.
    ##
    ##        ignoreExceptions (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore exceptions for the given URL. Defaults to `false`.
    ##
    ##        ignoreRawRules (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore raw rules for the given URL. Defaults to `false`.
    ##
    ##        ignoreRedirections (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore redirection rules for the given URL. Defaults to `false`.
    ##
    ##        skipBlocked (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not process rules for blocked URLs. Defaults to `false`.
    ##
    ##            This is similar to ClearURLs **"Allow domain blocking"** option, but instead of blocking access to the URL,
    ##            we just ignore all rulesets where it"s blocked.
    ##
    ##        stripDuplicates (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to strip fields with duplicate names. Defaults to `false`.
    ##
    ##        stripEmpty (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to strip fields with empty values. Defaults to `false`.
    ##
    ##    Usage examples:
    ##
    ##      Common rules (used to remove tracking fields found in the URL query)
    ##
    ##          .. code-block::
    ##            import unalix
    ##
    ##            const url: string = "https://deezer.com/track/891177062?utm_source=deezer"
    ##
    ##            doAssert clearUrl(url) == "https://deezer.com/track/891177062"
    ##
    ##      Redirection rules (used to extract redirect URLs found in any part of the URL)
    ##
    ##          .. code-block::
    ##            import unalix
    ##
    ##            const url: string = "https://www.google.com/url?q=https://pypi.org/project/Unalix"
    ##
    ##            doAssert clearUrl(url) == "https://pypi.org/project/Unalix"
    ##
    ##      Raw rules (used to remove tracking elements found in any part of the URL)
    ##
    ##          .. code-block::
    ##            import unalix
    ##
    ##            const url: string = "https://www.amazon.com/gp/B08CH7RHDP/ref=as_li_ss_tl"
    ##
    ##            doAssert clearUrl(url) == "https://www.amazon.com/gp/B08CH7RHDP"
    ##
    ##      Referral marketing rules (used to remove referral marketing fields found in the URL query)
    ##
    ##          .. code-block::
    ##            import unalix
    ##
    ##            const url: string = "https://natura.com.br/p/2458?consultoria=promotop"
    ##
    ##            doAssert clearUrl(url) == "https://natura.com.br/p/2458"
    ##

    var
        parsedUrl, redirectionResult: string
        uri: Uri
        exceptionMatched: bool

    parsedUrl = url

    block mainLoop:
        for ruleset in rulesetsTable:

            if skipBlocked and ruleset["completeProvider"].boolVal:
                continue

            # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
            if match(parsedUrl, ruleset["urlPattern"].regexVal):
                if not ignoreExceptions:
                    exceptionMatched = false
                    # https://docs.clearurls.xyz/latest/specs/rules/#exceptions
                    for exception in ruleset["exceptions"].seqRegexVal:
                        if match(parsedUrl, exception):
                            exceptionMatched = true
                            break
                    if exceptionMatched:
                        continue

                if not ignoreRedirections:
                    # https://docs.clearurls.xyz/latest/specs/rules/#redirections
                    for redirection in ruleset["redirections"].seqRegexVal:
                        redirectionResult = replacef(parsedUrl, redirection, "$1")

                        # Skip empty URLs
                        if redirectionResult == "":
                            continue

                        if redirectionResult == parsedUrl:
                            continue

                        uri = parseUri(decodeUrl(redirectionResult, decodePlus = false))

                        # Workaround for URLs without scheme (see https://github.com/ClearURLs/Addon/issues/71)
                        if uri.scheme == "":
                            uri.scheme = "http"

                        parsedUrl = clearUrl(
                            url = requoteUri($uri),
                            ignoreReferralMarketing = ignoreReferralMarketing,
                            ignoreRules = ignoreRules,
                            ignoreExceptions = ignoreExceptions,
                            ignoreRawRules = ignoreRawRules,
                            ignoreRedirections = ignoreRedirections,
                            skipBlocked = skipBlocked
                        )

                        break mainLoop

                uri = parseUri(parsedUrl)

                if uri.query != "":
                    if not ignoreRules:
                        # https://docs.clearurls.xyz/latest/specs/rules/#rules
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.query = replacef(uri.query, rule, "$1")
                    if not ignoreReferralMarketing:
                        # https://docs.clearurls.xyz/latest/specs/rules/#referralmarketing
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.query = replacef(uri.query, referral, "$1")

                # The anchor might contains tracking fields as well
                if uri.anchor != "":
                    if not ignoreRules:
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.anchor = replacef(uri.anchor, rule, "$1")
                    if not ignoreReferralMarketing:
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.anchor = replacef(uri.anchor, referral, "$1")

                if uri.path != "":
                    if not ignoreRawRules:
                        # https://docs.clearurls.xyz/latest/specs/rules/#rawrules
                        for rawRule in ruleset["rawRules"].seqRegexVal:
                            uri.path = replacef(uri.path, rawRule, "$1")

                parsedUrl = $uri

    uri = parseUri(parsedUrl)

    if len(uri.query) != 0:
        uri.query = filterQuery(
            uri.query,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    if len(uri.anchor) != 0:
        uri.anchor = filterQuery(
            uri.anchor,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    result = $uri

proc unshortUrl*(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false
): string =

    var
        redirectLocation: string
        totalRedirects = 0
        newUrl: string

    var
        resolverSocket: Socket
        genericSocket: Socket
        genericPort: int
        resolverResponse: Response
        genericResponse: Response
        dnsAnswer: JsonNode
        uri: Uri
        dnsCache: TableRef[string, string]

    let
        context: SslContext = newContext()
        maxRedirects: int = 13

    var
        response: string
        chunk: string
        count: int

    var
        httpVersion, statusCode, statusMessage: string
        key, value: string
        headers, body: string
        headersSeq: seq[(string, string)]

    var
        genericAddress: string

    newUrl = clearUrl(
        url = url,
        ignoreReferralMarketing = ignoreReferralMarketing,
        ignoreRules = ignoreRules,
        ignoreExceptions = ignoreExceptions,
        ignoreRawRules = ignoreRawRules,
        ignoreRedirections = ignoreRedirections,
        skipBlocked = skipBlocked,
        stripDuplicates = stripDuplicates,
        stripEmpty = stripEmpty
    )

    dnsCache = newTable[string, string]()

    while true:
        result = newUrl

        uri = parseUri(newUrl)

        genericSocket = newSocket()

        if uri.scheme == "http":
            genericPort = (if uri.port == "": 80 else: parseInt(uri.port))
        elif uri.scheme == "https":
            wrapSocket(context, genericSocket)
            genericPort = (if uri.port == "": 443 else: parseInt(uri.port))
        else:
            genericSocket.close()

            var
                err: UnsupportedProtocolError

            new(err)

            err.msg = "Unrecognized URI or unsupported protocol"
            err.url = newUrl

            raise err

        if dnsCache.hasKey(uri.hostname):
            genericAddress = dnsCache[uri.hostname]
        else:
            resolverSocket = newSocket()
            wrapSocket(context, resolverSocket)

            resolverSocket.connect("1.1.1.1", Port(443))
            resolverSocket.send(
                "GET /dns-query?name=" & uri.hostname & "&type=A HTTP/1.0\n" &
                "Host: cloudflare-dns.com\n" &
                "Accept: application/dns-json\n\n"
            )

            response = ""

            while true:
                chunk = ""

                try:
                    count = resolverSocket.recv(data = chunk, size = 1024, timeout = 3000)
                except Exception as e:
                    resolverSocket.close()
                    genericSocket.close()

                    var err:
                        ReadError

                    new(err)

                    err.msg = e.msg
                    err.url = newUrl
                    err.parent = e

                    raise err

                if count < 1:
                    break

                response.add(chunk)

            resolverSocket.close()

            (headers, body) = response.split("\r\n\r\n", maxsplit = 1)

            headersSeq = newSeq[(string, string)]()

            for (index, header) in pairs(headers.split("\r\n")):
                # This index is not a header
                if index == 0:
                    (httpVersion, statusCode, statusMessage) = header.split(" ", maxsplit = 2)
                    continue

                (key, value) = header.split(": ", maxsplit = 1)

                headersSeq.add((key, value))

            resolverResponse = initResponse(
                httpVersion = parseFloat(httpVersion.split("/")[1]),
                statusCode = parseInt(statusCode),
                statusMessage = statusMessage,
                headers = headersSeq,
                body = body
            )
            dnsAnswer = resolverResponse.getJson()

            if not dnsAnswer.hasKey("Answer"):
                var err:
                    ResolverError

                new(err)

                err.msg = "No address associated with hostname"
                err.url = newUrl

                raise err

            for answer in dnsAnswer["Answer"]:
                genericAddress = answer["data"].getStr()
                if genericAddress.isIpAddress():
                    break

            dnsCache[uri.hostname] = genericAddress

        uri.path = (if uri.path == "": "/" else: uri.path)

        genericSocket.connect(genericAddress, Port(genericPort))
        genericSocket.send(
            "GET " & (if uri.query != "": uri.path & "?" & uri.query else: uri.path) & " HTTP/1.0\n" &
            "Host: " & uri.hostname & "\n" &
            "Accept: */*\n" &
            "Accept-Encoding: identity\n" &
            "Connection: close\n" &
            "User-Agent: Unalix/0.5.1 (+https://github.com/AmanoTeam/Unalix-nim)\n\n"
        )

        response = ""

        while not ("\r\n\r\n" in response):
            chunk = ""

            try:
                count = genericSocket.recv(data = chunk, size = 1024, timeout = 3000)
            except Exception as e:
                genericSocket.close()

                var err:
                    ReadError

                err.msg = e.msg
                err.url = newUrl
                err.parent = e

                raise err

            if count < 1:
                break

            response.add(chunk)

        genericSocket.close()

        (headers, body) = response.split("\r\n\r\n", maxsplit = 1)

        headersSeq = newSeq[(string, string)]()

        for (index, header) in pairs(headers.split("\r\n")):
            # This index is not a header
            if index == 0:
                (httpVersion, statusCode, statusMessage) = header.split(" ", maxsplit = 2)
                continue

            (key, value) = header.split(": ", maxsplit = 1)

            headersSeq.add((key, value))

        genericResponse = initResponse(
            httpVersion = parseFloat(httpVersion.split("/")[1]),
            statusCode = parseInt(statusCode),
            statusMessage = statusMessage,
            headers = headersSeq,
            body = body
        )

        if genericResponse.hasHeader("Location"):
            redirectLocation = genericResponse.getHeader("Location")
        elif genericResponse.hasHeader("Content-Location"):
            redirectLocation = genericResponse.getHeader("Content-Location")
        else:
            break

        if redirectLocation != "":
            redirectLocation = redirectLocation.replace(" ", "%20")

            if not (redirectLocation.startsWith("https://") or redirectLocation.startsWith("http://")):
                if redirectLocation.startsWith("//"):
                    redirectLocation = uri.scheme & "://" & replacef(redirectLocation, re"^/*", "") 
                elif redirectLocation.startsWith("/"):
                    redirectLocation = uri.scheme & "://" & uri.hostname & redirectLocation
                else:
                    redirectLocation = uri.scheme & "://" & uri.hostname & (if uri.path != "/": parentDir(uri.path) else: uri.path) & redirectLocation

            if redirectLocation == newUrl:
                break

            totalRedirects += 1

            # Strip tracking fields from the redirect URL
            newUrl = clearUrl(
                url = redirectLocation,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked,
                stripDuplicates = stripDuplicates,
                stripEmpty = stripEmpty
            )

            if totalRedirects > maxRedirects:
                var
                    err: TooManyRedirectsError

                new(err)

                err.msg = "Exceeded maximum allowed redirects"
                err.url = newUrl

                raise err

            continue

        break


proc asyncUnshortUrl*(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false
): Future[string] {.async, gcsafe.} =

    var
        redirectLocation: string
        totalRedirects = 0
        newUrl: string

    var
        resolverSocket: AsyncSocket
        genericSocket: AsyncSocket
        genericPort: int
        resolverResponse: Response
        genericResponse: Response
        dnsAnswer: JsonNode
        uri: Uri
        dnsCache: TableRef[string, string]

    let
        context: SslContext = newContext()
        maxRedirects: int = 13

    var
        response: string
        chunk: string
        count: int

    var
        httpVersion, statusCode, statusMessage: string
        key, value: string
        headers, body: string
        headersSeq: seq[(string, string)]

    var
        genericAddress: string

    newUrl = clearUrl(
        url = url,
        ignoreReferralMarketing = ignoreReferralMarketing,
        ignoreRules = ignoreRules,
        ignoreExceptions = ignoreExceptions,
        ignoreRawRules = ignoreRawRules,
        ignoreRedirections = ignoreRedirections,
        skipBlocked = skipBlocked,
        stripDuplicates = stripDuplicates,
        stripEmpty = stripEmpty
    )

    dnsCache = newTable[string, string]()

    while true:
        result = newUrl

        uri = parseUri(newUrl)

        genericSocket = newAsyncSocket()

        if uri.scheme == "http":
            genericPort = (if uri.port == "": 80 else: parseInt(uri.port))
        elif uri.scheme == "https":
            wrapSocket(context, genericSocket)
            genericPort = (if uri.port == "": 443 else: parseInt(uri.port))
        else:
            genericSocket.close()

            var
                err: UnsupportedProtocolError

            new(err)

            err.msg = "Unrecognized URI or unsupported protocol"
            err.url = newUrl

            raise err

        if dnsCache.hasKey(uri.hostname):
            genericAddress = dnsCache[uri.hostname]
        else:
            resolverSocket = newAsyncSocket()
            wrapSocket(context, resolverSocket)

            await resolverSocket.connect("1.1.1.1", Port(443))
            await resolverSocket.send(
                "GET /dns-query?name=" & uri.hostname & "&type=A HTTP/1.0\n" &
                "Host: cloudflare-dns.com\n" &
                "Accept: application/dns-json\n\n"
            )

            response = ""

            while true:

                try:
                    chunk = await resolverSocket.recv(size = 1024)
                    count = len(chunk)
                except Exception as e:
                    resolverSocket.close()
                    genericSocket.close()

                    var err:
                        ReadError

                    new(err)

                    err.msg = e.msg
                    err.url = newUrl
                    err.parent = e

                    raise err

                if count < 1:
                    break

                response.add(chunk)

            resolverSocket.close()

            (headers, body) = response.split("\r\n\r\n", maxsplit = 1)

            headersSeq = newSeq[(string, string)]()

            for (index, header) in pairs(headers.split("\r\n")):
                # This index is not a header
                if index == 0:
                    (httpVersion, statusCode, statusMessage) = header.split(" ", maxsplit = 2)
                    continue

                (key, value) = header.split(": ", maxsplit = 1)

                headersSeq.add((key, value))

            resolverResponse = initResponse(
                httpVersion = parseFloat(httpVersion.split("/")[1]),
                statusCode = parseInt(statusCode),
                statusMessage = statusMessage,
                headers = headersSeq,
                body = body
            )
            dnsAnswer = resolverResponse.getJson()

            if not dnsAnswer.hasKey("Answer"):
                var err:
                    ResolverError

                new(err)

                err.msg = "No address associated with hostname"
                err.url = newUrl

                raise err

            for answer in dnsAnswer["Answer"]:
                genericAddress = answer["data"].getStr()
                if genericAddress.isIpAddress():
                    break

            dnsCache[uri.hostname] = genericAddress

        uri.path = (if uri.path == "": "/" else: uri.path)

        await genericSocket.connect(genericAddress, Port(genericPort))
        await genericSocket.send(
            "GET " & (if uri.query != "": uri.path & "?" & uri.query else: uri.path) & " HTTP/1.0\n" &
            "Host: " & uri.hostname & "\n" &
            "Accept: */*\n" &
            "Accept-Encoding: identity\n" &
            "Connection: close\n" &
            "User-Agent: Unalix/0.5.1 (+https://github.com/AmanoTeam/Unalix-nim)\n\n"
        )

        response = ""

        while not ("\r\n\r\n" in response):

            try:
                chunk = await genericSocket.recv(size = 1024)
                count = len(chunk)
            except Exception as e:
                genericSocket.close()

                var err:
                    ReadError

                err.msg = e.msg
                err.url = newUrl
                err.parent = e

                raise err

            if count < 1:
                break

            response.add(chunk)

        genericSocket.close()

        (headers, body) = response.split("\r\n\r\n", maxsplit = 1)

        headersSeq = newSeq[(string, string)]()

        for (index, header) in pairs(headers.split("\r\n")):
            # This index is not a header
            if index == 0:
                (httpVersion, statusCode, statusMessage) = header.split(" ", maxsplit = 2)
                continue

            (key, value) = header.split(": ", maxsplit = 1)

            headersSeq.add((key, value))

        genericResponse = initResponse(
            httpVersion = parseFloat(httpVersion.split("/")[1]),
            statusCode = parseInt(statusCode),
            statusMessage = statusMessage,
            headers = headersSeq,
            body = body
        )

        if genericResponse.hasHeader("Location"):
            redirectLocation = genericResponse.getHeader("Location")
        elif genericResponse.hasHeader("Content-Location"):
            redirectLocation = genericResponse.getHeader("Content-Location")
        else:
            break

        if redirectLocation != "":
            redirectLocation = redirectLocation.replace(" ", "%20")

            if not (redirectLocation.startsWith("https://") or redirectLocation.startsWith("http://")):
                if redirectLocation.startsWith("//"):
                    redirectLocation = uri.scheme & "://" & replacef(redirectLocation, re"^/*", "") 
                elif redirectLocation.startsWith("/"):
                    redirectLocation = uri.scheme & "://" & uri.hostname & redirectLocation
                else:
                    redirectLocation = uri.scheme & "://" & uri.hostname & (if uri.path != "/": parentDir(uri.path) else: uri.path) & redirectLocation

            if redirectLocation == newUrl:
                break

            totalRedirects += 1

            # Strip tracking fields from the redirect URL
            newUrl = clearUrl(
                url = redirectLocation,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked,
                stripDuplicates = stripDuplicates,
                stripEmpty = stripEmpty
            )

            if totalRedirects > maxRedirects:
                var
                    err: TooManyRedirectsError

                new(err)

                err.msg = "Exceeded maximum allowed redirects"
                err.url = newUrl

                raise err

            continue

        break
