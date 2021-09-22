import sugar
import tables
import net
import strutils
import json
import uri
import re
import os
import strformat
import httpcore
import times

import ./types
import ./exceptions
import ./rulesets
import ./utils
import ./config

when defined(android):
    {.passC: "-I" & parentDir(currentSourcePath) / "android".}
    {.compile: "android/glob.c".}

proc compileRulesets(rulesetsList: JsonNode): seq[TableRef[string, RulesetNode]] =
    ## Compile rulesets from a JsonNode object

    var rulesets = newSeq[TableRef[string, RulesetNode]]()

    var
        table: TableRef[string, RulesetNode]
        rules, referralMarketing, rawRules, exceptions, redirections: seq[Regex]

    for provider in rulesetsList:

        table = newTable[string, RulesetNode]()

        # This field is ignored by Unalix, we are leaving it here just for reference
        # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
        table["providerName"] = RulesetNode(kind: nkString, strVal: provider["providerName"].getStr())

        # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
        table["urlPattern"] = RulesetNode(kind: nkRegex, regexVal: rex(provider["urlPattern"].getStr()))

        # https://docs.clearurls.xyz/latest/specs/rules/#completeprovider
        table["completeProvider"] = RulesetNode(kind: nkBool, boolVal: provider["completeProvider"].getBool())

        # https://docs.clearurls.xyz/latest/specs/rules/#rules
        rules = block: collect newSeq: (for rule in provider["rules"]: rex("(%(?:26|23)|&|^)" & rule.getStr() & "(?:(?:=|%3[Dd])[^&]*)"))
        table["rules"] = RulesetNode(kind: nkSeqRegex, seqRegexVal: rules)

        # https://docs.clearurls.xyz/latest/specs/rules/#rawrules
        rawRules = block: collect newSeq: (for rawRule in provider["rawRules"]: rex(rawRule.getStr()))
        table["rawRules"] = RulesetNode(kind: nkSeqRegex, seqRegexVal: rawRules)

        # https://docs.clearurls.xyz/latest/specs/rules/#referralmarketing
        referralMarketing = block: collect newSeq: (for referral in provider["referralMarketing"]: rex("(%(?:26|23)|&|^)" & referral.getStr() & "(?:(?:=|%3[Dd])[^&]*)"))
        table["referralMarketing"] = RulesetNode(kind: nkSeqRegex, seqRegexVal: referralMarketing)

        # https://docs.clearurls.xyz/latest/specs/rules/#exceptions
        exceptions = block: collect newSeq: (for exception in provider["exceptions"]: rex(exception.getStr()))
        table["exceptions"] = RulesetNode(kind: nkSeqRegex, seqRegexVal: exceptions)

        # https://docs.clearurls.xyz/latest/specs/rules/#redirections
        redirections = block: collect newSeq: (for redirection in provider["redirections"]: rex(redirection.getStr() & ".*"))
        table["redirections"] = RulesetNode(kind: nkSeqRegex, seqRegexVal: redirections)

        # This field is ignored by Unalix, we are leaving it here just for reference
        # https://docs.clearurls.xyz/latest/specs/rules/#forceredirection
        table["forceRedirection"] = RulesetNode(kind: nkBool, boolVal: provider["forceRedirection"].getBool())

        rulesets.add(y = table)

    result = rulesets


proc compileRedirects(redirectsList: JsonNode): seq[TableRef[string, RulesetNode]] =
    ## Compile redirects from a JsonNode object

    var redirects = newSeq[TableRef[string, RulesetNode]]()

    var
        table: TableRef[string, RulesetNode]
        domains: seq[string]
        rules: seq[Regex]

    for provider in redirectsList:

        table = newTable[string, RulesetNode]()

        # This field is ignored by Unalix, we are leaving it here just for reference
        table["providerName"] = RulesetNode(kind: nkString, strVal: provider["providerName"].getStr())

        table["urlPattern"] = RulesetNode(kind: nkRegex, regexVal: rex(provider["urlPattern"].getStr()))

        domains = block: collect newSeq: (for domain in provider["domains"]: domain.getStr())
        table["domains"] = RulesetNode(kind: nkSeqString, seqStringVal: domains)

        rules = block: collect newSeq: (for rule in provider["rules"]: rex(rule.getStr()))
        table["rules"] = RulesetNode(kind: nkSeqRegex, seqRegexVal: rules)

        redirects.add(y = table)

    result = redirects

var
    rulesetsTable {.threadvar.}: seq[TableRef[string, RulesetNode]]
    redirectsTable {.threadvar.}: seq[TableRef[string, RulesetNode]]

rulesetsTable = compileRulesets(rulesetsList = rulesetsNode)
redirectsTable = compileRedirects(redirectsList = redirectsNode)

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

    var
        surl, redirectionResult: string
        uri: Uri
        exceptionMatched: bool

    # "surl" means "strip/striped URL"
    surl = url

    block mainLoop:
        for ruleset in rulesetsTable:

            if skipBlocked and ruleset["completeProvider"].boolVal:
                continue

            # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
            if surl.match(pattern = ruleset["urlPattern"].regexVal):
                if not ignoreExceptions:
                    exceptionMatched = false
                    # https://docs.clearurls.xyz/latest/specs/rules/#exceptions
                    for exception in ruleset["exceptions"].seqRegexVal:
                        if surl.match(pattern = exception):
                            exceptionMatched = true
                            break
                    if exceptionMatched:
                        continue

                if not ignoreRedirections:
                    # https://docs.clearurls.xyz/latest/specs/rules/#redirections
                    for redirection in ruleset["redirections"].seqRegexVal:
                        redirectionResult = surl.replacef(sub = redirection, by = "$1")

                        # Skip empty URLs
                        if redirectionResult.isEmptyOrWhitespace():
                            continue

                        if redirectionResult == surl:
                            continue

                        uri = parseUri(
                            uri = decodeUrl(s = redirectionResult, decodePlus = false)
                        )

                        # Workaround for URLs without scheme (see https://github.com/ClearURLs/Addon/issues/71)
                        if uri.scheme.isEmptyOrWhitespace():
                            uri.scheme = "http"

                        surl = clearUrl(
                            url = requoteUri(uri = $uri),
                            ignoreReferralMarketing = ignoreReferralMarketing,
                            ignoreRules = ignoreRules,
                            ignoreExceptions = ignoreExceptions,
                            ignoreRawRules = ignoreRawRules,
                            ignoreRedirections = ignoreRedirections,
                            skipBlocked = skipBlocked
                        )

                        break mainLoop

                uri = parseUri(uri = surl)

                if not uri.query.isEmptyOrWhitespace():
                    if not ignoreRules:
                        # https://docs.clearurls.xyz/latest/specs/rules/#rules
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.query = uri.query.replacef(sub = rule, by = "$1")
                    if not ignoreReferralMarketing:
                        # https://docs.clearurls.xyz/latest/specs/rules/#referralmarketing
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.query = uri.query.replacef(sub = referral, by = "$1")

                # The anchor might contains tracking fields as well
                if not uri.anchor.isEmptyOrWhitespace():
                    if not ignoreRules:
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.anchor = uri.anchor.replacef(sub = rule, by = "$1")
                    if not ignoreReferralMarketing:
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.anchor = uri.anchor.replacef(sub = referral, by = "$1")

                if not uri.path.isEmptyOrWhitespace():
                    if not ignoreRawRules:
                        # https://docs.clearurls.xyz/latest/specs/rules/#rawrules
                        for rawRule in ruleset["rawRules"].seqRegexVal:
                            uri.path = uri.path.replacef(sub = rawRule, by = "$1")

                surl = $uri

    uri = parseUri(uri = surl)

    if not uri.query.isEmptyOrWhitespace():
        uri.query = filterQuery(
            query = uri.query,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    if not uri.anchor.isEmptyOrWhitespace():
        uri.anchor = filterQuery(
            query = uri.anchor,
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
    stripEmpty: bool = false,
    httpMethod: HttpMethod = defaultHttpMethod,
    parseDocuments: bool = false,
    httpMaxRedirects: int = defaultHttpMaxRedirects,
    httpTimeout: int = defaultHttpTimeout,
    httpHeaders: HttpHeaders = newHttpHeaders(defaultHttpHeaders),
    httpMaxFetchSize: int = defaultHttpMaxFetchSize,
    sslContext: SslContext = newContext(),
    httpMaxRetries: int = defaultHttpMaxRetries,
    httpStatusRetry: seq[HttpCode] = defaultHttpStatusRetry
): string = 

    var
        totalRedirects, totalRetries, retryAfter, httpPort, count: int
        redirectLocation, surl, httpPath, payload, chunks, chunk: string
        headerLines, body, key, value, httpVersion, statusCode, statusMessage: string
        timeNow, timeInFuture: DateTime
        redirectMatches: bool
        socket: Socket
        response: Response
        uri: Uri
        headers: seq[(string, string)]
        matches: array[0..1, string]

    surl = clearUrl(
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

    while true:
        result = surl

        uri = parseUri(uri = surl)

        socket = newSocket()

        case uri.scheme:
        of "http":
            httpPort = if uri.port.isEmptyOrWhitespace(): 80 else: parseInt(s = uri.port)
        of "https":
            sslContext.wrapSocket(socket = socket)
            httpPort = if uri.port.isEmptyOrWhitespace(): 443 else: parseInt(s = uri.port)
        else:
            socket.close()

            var
                err: UnsupportedProtocolError

            new(err)

            err.msg = "Unrecognized URI or unsupported protocol"
            err.url = surl

            raise err

        if uri.path.isEmptyOrWhitespace():
            uri.path = "/"

        if not uri.query.isEmptyOrWhitespace():
            httpPath = &"{uri.path}?{uri.query}"
        else:
            httpPath = uri.path

        payload = &"{httpMethod} {httpPath} HTTP/1.0\nHost: {uri.hostname}\n"

        for (key, value) in httpHeaders.pairs(): 
            payload.add(y = &"{key}: {value}\n")
        payload.add(y = "\n")

        try:
            socket.connect(
                address = uri.hostname,
                port = Port(httpPort),
                timeout = httpTimeout
            )
            socket.send(data = payload, flags = {})
        except Exception as e:
            socket.close()
            
            # Retry based on connection error
            if httpMaxRetries > 0:
                totalRetries += 1
                
                if totalRetries > httpMaxRetries:
                    var err:
                        MaxRetriesError
                    
                    new(err)
                    
                    err.msg = "Exceeded maximum allowed retries"
                    err.url = surl
                    err.parent = e
                    
                    raise err
                
                continue
            
            var err:
                ConnectError

            new(err)

            err.msg = e.msg
            err.url = surl
            err.parent = e

            raise err

        chunks = ""
        
        # Start reading headers
        while not ("\r\n\r\n" in chunks):
            chunk = ""

            try:
                count = socket.recv(data = chunk, size = 1024, timeout = httpTimeout, flags = {})
            except Exception as e:
                socket.close()

                var err:
                    ReadError

                err.msg = e.msg
                err.url = surl
                err.parent = e

                raise err

            if count < 1:
                break

            chunks.add(y = chunk)

        (headerLines, body) = chunks.split(sep = "\r\n\r\n", maxsplit = 1)

        # Start reading body
        if httpMethod != HttpHead and parseDocuments:
            while len(body) <= httpMaxFetchSize:
                chunk = ""
    
                try:
                    count = socket.recv(data = chunk, size = 1024, timeout = httpTimeout, flags = {})
                except Exception as e:
                    socket.close()
    
                    var err:
                        ReadError
    
                    err.msg = e.msg
                    err.url = surl
                    err.parent = e
    
                    raise err
    
                if count < 1:
                    break
    
                body.add(y = chunk)

        socket.close()

        headers = newSeq[(string, string)]()

        for (index, headerLine) in headerLines.split(sep = "\r\n").pairs():
            # This index is not a header
            if index == 0:
                (httpVersion, statusCode, statusMessage) = headerLine.split(sep = " ", maxsplit = 2)
                continue

            (key, value) = headerLine.split(sep = ": ", maxsplit = 1)

            headers.add(y = (key, value))

        response = initResponse(
            httpVersion = if parseFloat(s = httpVersion.split(sep = "/")[1]) == 1.1: HttpVer11 else: HttpVer10,
            statusCode = parseInt(s = statusCode).HttpCode,
            headers = newHttpHeaders(headers),
            body = body
        )

        # Retry based on status code
        if httpMaxRetries > 0 and response.statusCode in httpStatusRetry:
            if response.headers.hasKey(key = "Retry-After"):
                try:
                    retryAfter = parseInt(s = response.headers["Retry-After"]) * 1000
                except:
                    timeNow = now().utc()
                    timeInFuture = parse(
                        input = response.headers["Retry-After"],
                        f = "ddd, d MMM yyyy HH:mm:ss 'GMT'",
                        zone = utc()
                    )
                    retryAfter = int(inMilliseconds(dur = timeInFuture - timeNow))
                sleep(milsecs = retryAfter)
            
            totalRetries += 1
            
            if totalRetries > httpMaxRetries:
                var err:
                    MaxRetriesError
                
                new(err)
                
                err.msg = "Exceeded maximum allowed retries"
                err.url = surl
                
                raise err
            
            continue

        if response.statusCode.is3xx() and response.headers.hasKey(key = "Location"):
            redirectLocation = response.headers["Location"].toString()
        elif response.statusCode.is2xx() and response.headers.hasKey(key = "Content-Location"):
            redirectLocation = response.headers["Content-Location"].toString()
        else:
            redirectLocation = ""

        if not redirectLocation.isEmptyOrWhitespace():
            redirectLocation = redirectLocation.replace(sub = " ", by = "%20")
            if not (redirectLocation.startsWith(prefix = "https://") or redirectLocation.startsWith(prefix = "http://")):
                if redirectLocation.startsWith(prefix = "//"):
                    redirectLocation = &"{uri.scheme}://" & redirectLocation.replacef(sub = re"^/*", by = "") 
                elif redirectLocation.startsWith(prefix = '/'):
                    redirectLocation = &"{uri.scheme}://{uri.hostname}{redirectLocation}"
                else:
                    redirectLocation = &"{uri.scheme}://{uri.hostname}" & (if uri.path != "/": parentDir(uri.path) else: uri.path) & redirectLocation

            if redirectLocation == surl:
                break

            totalRedirects += 1

            # Strip tracking fields from the redirect URL
            surl = clearUrl(
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

            if totalRedirects > httpMaxRedirects:
                var
                    err: TooManyRedirectsError

                new(err)

                err.msg = "Exceeded maximum allowed redirects"
                err.url = surl

                raise err

            continue

        if parseDocuments:
            uri = parseUri(uri = surl)
            redirectMatches = false

            block redirectLoop:
                for redirect in redirectsTable:
                    if surl.match(pattern = redirect["urlPattern"].regexVal) or uri.hostname in redirect["domains"].seqStringVal:
                        for ruleset in redirect["rules"].seqRegexVal:
                            if response.body.find(pattern = ruleset, matches = matches) > -1:
                                (redirectLocation, redirectMatches) = (matches[0], true)
                                break redirectLoop
            
            if redirectMatches:
                surl = clearUrl(
                    url = requoteUri(uri = htmlUnescape(s = redirectLocation)),
                    ignoreReferralMarketing = ignoreReferralMarketing,
                    ignoreRules = ignoreRules,
                    ignoreExceptions = ignoreExceptions,
                    ignoreRawRules = ignoreRawRules,
                    ignoreRedirections = ignoreRedirections,
                    skipBlocked = skipBlocked,
                    stripDuplicates = stripDuplicates,
                    stripEmpty = stripEmpty
                )
                
                totalRedirects += 1
                
                if totalRedirects > httpMaxRedirects:
                    var
                        err: TooManyRedirectsError

                    new(err)

                    err.msg = "Exceeded maximum allowed redirects"
                    err.url = surl

                    raise err
                
                continue

        break


proc clearUrl(
    url: cstring,
    ignoreReferralMarketing: cbool = false,
    ignoreRules: cbool = false,
    ignoreExceptions: cbool = false,
    ignoreRawRules: cbool = false,
    ignoreRedirections: cbool = false,
    skipBlocked: cbool = false,
    stripDuplicates: cbool = false,
    stripEmpty: cbool = false
): cstring {.cdecl, exportc, dynlib.} =

    let cleanedUrl: string = clearUrl(
        url = $url,
        ignoreReferralMarketing = ignoreReferralMarketing,
        ignoreRules = ignoreRules,
        ignoreExceptions = ignoreExceptions,
        ignoreRawRules = ignoreRawRules,
        ignoreRedirections = ignoreRedirections,
        skipBlocked = skipBlocked,
        stripDuplicates = stripDuplicates,
        stripEmpty = stripEmpty
    )
    
    result = cstring(cleanedUrl)

proc unshortUrl*(
    url: cstring,
    ignoreReferralMarketing: cbool = false,
    ignoreRules: cbool = false,
    ignoreExceptions: cbool = false,
    ignoreRawRules: cbool = false,
    ignoreRedirections: cbool = false,
    skipBlocked: cbool = false,
    stripDuplicates: cbool = false,
    stripEmpty: cbool = false,
    httpMethod: cstring = cstring($defaultHttpMethod),
    parseDocuments: cbool = false,
    httpMaxRedirects: cint = cint(defaultHttpMaxRedirects),
    httpTimeout: cint = cint(defaultHttpTimeout),
    httpMaxFetchSize: cint = cint(defaultHttpMaxFetchSize),
    httpMaxRetries: cint = cint(defaultHttpMaxRetries)
): cstring {.cdecl, exportc, dynlib.} =
    
    var
        cleanedUrl: string
        NHttpMethod: HttpMethod
    
    case $httpMethod:
    of "HEAD":
        NHttpMethod = HttpHead
    of "GET":
        NHttpMethod = HttpGet
    of "PUT":
        NHttpMethod = HttpPut
    of "DELETE":
        NHttpMethod = HttpDelete
    of "TRACE":
        NHttpMethod = HttpTrace
    of "OPTIONS":
        NHttpMethod = HttpOptions
    of "CONNECT":
        NHttpMethod = HttpConnect
    of "PATCH":
        NHttpMethod = HttpPatch
    else:
        raise newException(ValueError, "Invalid HTTP method")
    
    try:
        cleanedUrl = unshortUrl(
            url = $url,
            ignoreReferralMarketing = ignoreReferralMarketing,
            ignoreRules = ignoreRules,
            ignoreExceptions = ignoreExceptions,
            ignoreRawRules = ignoreRawRules,
            ignoreRedirections = ignoreRedirections,
            skipBlocked = skipBlocked,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty,
            httpMethod = NHttpMethod,
            parseDocuments = parseDocuments,
            httpMaxRedirects = int(httpMaxRedirects),
            httpTimeout = int(httpTimeout),
            httpMaxFetchSize = int(httpMaxFetchSize),
            httpMaxRetries = int(httpMaxRetries)
        )
    except ConnectError as e:
        cleanedUrl = e.url
    
    return cstring(cleanedUrl)
            