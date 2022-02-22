import std/asyncdispatch
import std/uri
import std/net
import std/asyncnet
import std/sequtils
import std/strutils except unescape
import std/sugar
import std/nativesockets
import std/httpcore
import std/json
import std/tables
import std/re
import std/pegs
import std/os

import ./config
import ./types
import ./utils
import ./rulesets
import ./exceptions
import ./url_cleaner

proc compileRedirects(redirectsList: JsonNode): seq[TableRef[string, RulesetNode]] =
    ## Compile redirects from a JsonNode object

    result = newSeq[TableRef[string, RulesetNode]]()

    for provider in redirectsList:
        var table: TableRef[string, RulesetNode] = newTable[string, RulesetNode]()

        # This field is ignored by Unalix, we are leaving it here just for reference
        table["providerName"] = RulesetNode(kind: nkString, strVal: provider["providerName"].getStr())

        table["urlPattern"] = RulesetNode(kind: nkRegex, regexVal: rex(provider["urlPattern"].getStr()))

        table["rules"] = RulesetNode(
            kind: nkSeqRegex,
            seqRegexVal: block: collect newSeq: (for rule in provider["rules"]: rex(rule.getStr()))
        )

        result.add(table)

var redirectsTable {.threadvar.}: seq[TableRef[string, RulesetNode]]
redirectsTable = compileRedirects(redirectsList = redirectsNode)

proc parseHeaders(chunks: string): Response =

    let parts: seq[string] = chunks.split(sep = "\r\n\r\n", maxsplit = 1)
    
    if len(parts) != 2:
        raise (ref RemoteProtocolError)(msg: "Malformed server response")

    var headers: seq[(string, string)] = newSeq[(string, string)]()
    
    var
        httpVersion: HttpVersion
        statusCode: HttpCode
        statusMessage: string

    for (index, line) in parts[0].split(sep = "\r\n").pairs():
        # This index is not a header
        if index == 0:
            let parts: seq[string] = line.split(sep = " ", maxsplit = 2)
            
            if len(parts) != 3:
                raise (ref RemoteProtocolError)(msg: "Malformed server response")
            
            # Parse HTTP version
            let values: seq[string] = parts[0].split(sep = "/")
            
            if len(values) != 2:
                raise (ref RemoteProtocolError)(msg: "Malformed server response")
            
            if values[0] != "HTTP":
                raise (ref RemoteProtocolError)(msg: "Unknown protocol name: $1" % [values[0]])
            
            case values[1]
            of "1.0":
                httpVersion = HttpVer10
            of "1.1":
                httpVersion = HttpVer11
            else:
                raise (ref RemoteProtocolError)(msg: "Unsupported protocol version: $1" % [values[1]])
            
            # Parse status code
            case parts[1]
            of "100":
                statusCode = Http100
                statusMessage = "Continue"
            of "101":
                statusCode = Http101
                statusMessage = "Switching Protocols"
            of "200":
                statusCode = Http200
                statusMessage = "OK"
            of "201":
                statusCode = Http201
                statusMessage = "Created"
            of "202":
                statusCode = Http202
                statusMessage = "Accepted"
            of "203":
                statusCode = Http203
                statusMessage = "Non-Authoritative Information"
            of "204":
                statusCode = Http204
                statusMessage = "Non-Authoritative Information"
            of "205":
                statusCode = Http205
                statusMessage = "Reset Content"
            of "206":
                statusCode = Http206
                statusMessage = "Partial Content"
            of "300":
                statusCode = Http300
                statusMessage = "Multiple Choices"
            of "301":
                statusCode = Http301
                statusMessage = "Moved Permanently"
            of "302":
                statusCode = Http302
                statusMessage = "Found"
            of "303":
                statusCode = Http303
                statusMessage = "See Other"
            of "304":
                statusCode = Http304
                statusMessage = "Not Modified"
            of "305":
                statusCode = Http305
                statusMessage = "Use Proxy"
            of "307":
                statusCode = Http307
                statusMessage = "Temporary Redirect"
            of "400":
                statusCode = Http400
                statusMessage = "Bad Request"
            of "401":
                statusCode = Http401
                statusMessage = "Unauthorized"
            of "402":
                when (NimMajor, NimMinor) < (1, 6):
                    statusCode = HttpCode(402)
                else:
                    statusCode = Http402
                statusMessage = "Payment Required"
            of "403":
                statusCode = Http403
                statusMessage = "Forbidden"
            of "404":
                statusCode = Http404
                statusMessage = "Not Found"
            of "405":
                statusCode = Http405
                statusMessage = "Method Not Allowed"
            of "406":
                statusCode = Http406
                statusMessage = "Not Acceptable"
            of "407":
                statusCode = Http407
                statusMessage = "Proxy Authentication Required"
            of "408":
                statusCode = Http408
                statusMessage = "Request Time-out"
            of "409":
                statusCode = Http409
                statusMessage = "Conflict"
            of "410":
                statusCode = Http410
                statusMessage = "Gone"
            of "411":
                statusCode = Http411
                statusMessage = "Length Required"
            of "412":
                statusCode = Http412
                statusMessage = "Precondition Failed"
            of "413":
                statusCode = Http413
                statusMessage = "Request Entity Too Large"
            of "414":
                statusCode = Http414
                statusMessage = "Request-URI Too Large"
            of "415":
                statusCode = Http415
                statusMessage = "Unsupported Media Type"
            of "416":
                statusCode = Http416
                statusMessage = "Requested range not satisfiable"
            of "417":
                statusCode = Http417
                statusMessage = "Expectation Failed"
            of "500":
                statusCode = Http500
                statusMessage = "Internal Server Error"
            of "501":
                statusCode = Http501
                statusMessage = "Not Implemented"
            of "502":
                statusCode = Http502
                statusMessage = "Bad Gateway"
            of "503":
                statusCode = Http503
                statusMessage = "Service Unavailable"
            of "504":
                statusCode = Http504
                statusMessage = "Gateway Time-out"
            of "505":
                statusCode = Http505
                statusMessage = "HTTP Version not supported"
            else:
                raise (ref RemoteProtocolError)(msg: "Unknown status code: $1" % [parts[1]])
            
            continue

        var key, value: string
        (key, value) = line.split(sep = ": ", maxsplit = 1)

        headers.add((key, value))

    result = initResponse(
        httpVersion = httpVersion,
        statusCode = statusCode,
        statusMessage = statusMessage,
        headers = newHttpHeaders(headers),
        body = parts[1]
    )

proc closeFd(self: Socket | AsyncSocket): void =
    
    let fd: SocketHandle = self.getFd()
    
    when self is AsyncSocket:
        AsyncFD(fd).unregister()
        fd.close()
    else:
        fd.close()

proc resolveHostname(hostname: string, port: Port): string =
    
    let ai: ptr AddrInfo = getAddrInfo(address = hostname, port = port, domain = AF_UNSPEC)
    let address: ptr SockAddr = ai.ai_addr

    result = address.getAddrString()
    freeAddrInfo(a1 = ai)

proc unshortUrl*(
    self: SyncUnalix | AsyncUnalix,
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false,
    parseDocuments: bool = false,
    timeout: int = DEFAULT_TIMEOUT,
    headers: seq[(string, string)] = DEFAULT_HTTP_HEADERS,
    maxRedirects: int = DEFAULT_MAX_REDIRECTS,
    sslContext: SslContext = newContext()
): Future[string] {.multisync, gcsafe.} =
    
    if not (url.startsWith(prefix = "http") or url.startsWith(prefix = "https")):
        raise (ref UnsupportedProtocolError)(msg: "Unrecognized URI or unsupported protocol", url: url)
    
    var thisUrl: string = clearUrl(
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

    var currentRedirects: int = 0

    while true:
        if not (thisUrl.startsWith(prefix = "http") or thisUrl.startsWith(prefix = "https")):
            raise (ref UnsupportedProtocolError)(msg: "Unrecognized URI or unsupported protocol", url: thisUrl)

        var uri: Uri = parseUri(uri = thisUrl)

        # Get port
        let port: int = (
            if uri.port.isEmptyOrWhitespace():
                case uri.scheme
                of "http":
                    80
                of "https":
                    443
                else:
                    0
            else:
                uri.port.parseInt()
        )

        let address: IpAddress = (
            if isIpAddress(addressStr = uri.hostname):
                parseIpAddress(addressStr = uri.hostname)
            else:
                try:
                    parseIpAddress(addressStr = resolveHostname(hostname = uri.hostname, port = Port(port)))
                except Exception as e:
                    raise (ref ResolverError)(msg: e.msg, url: thisUrl, parent: e)
        )
        
        let domain: Domain = (
            case address.family
            of IPv6:
                AF_INET6
            of IPv4:
                AF_INET
        )

        # Build hostname
        let hostname: string = (
            if (uri.scheme == "http" and port != 80) or (uri.scheme == "https" and port != 443):
                if isIpAddress(addressStr = uri.hostname) and (domain == AF_INET6):
                    "[$1]:$2" % [uri.hostname, $port]
                else:
                    "$1:$2" % [uri.hostname, $port]
            else:
                if isIpAddress(addressStr = uri.hostname) and (domain == AF_INET6):
                    "[$1]" % [uri.hostname]
                else:
                    uri.hostname
        )

        when self is AsyncUnalix:
            let socket: AsyncSocket = newAsyncSocket(
                domain = domain,
                sockType = SOCK_STREAM,
                protocol = IPPROTO_TCP,
                buffered = false
            )
        else:
            let socket: Socket = newSocket(
                domain = domain,
                sockType = SOCK_STREAM,
                protocol = IPPROTO_TCP,
                buffered = false
            )

        socket.setSockOpt(opt = OptNoDelay, value = true, level = IPPROTO_TCP.cint)
        
        # Build raw HTTP request
        if uri.path.isEmptyOrWhitespace():
            uri.path = "/"
        
        let data: string = (
            "GET $1 HTTP/1.0\nHost: $2\n$3\n\n" % [
                (
                    if uri.query.isEmptyOrWhitespace():
                        uri.path
                    else:
                        "$1?$2" % [uri.path, uri.query]
                ),
                hostname,
                (
                    block: collect newSeq: (
                        for (key, value) in headers:
                            "$1: $2" % [key, value]
                    )
                ).join(sep = "\n")
            ]
        )

        # Attempt to connect
        when self is AsyncUnalix:
            let future: Future[void] = socket.connect(address = $address, port = Port(port))
            try:
                await future or sleepAsync(ms = timeout)
            except Exception as e:
                socket.closeFd()
                raise (ref ConnectError)(msg: e.msg, url: thisUrl, parent: e)

            if not future.finished():
                future.fail(error = (ref TimeoutError)(msg: "Call to 'connect' timed out."))

            if future.failed():
                socket.closeFd()

                let e: ref Exception = future.readError()
                raise (ref ConnectError)(msg: e.msg, url: thisUrl, parent: e)
        else:
            try:
                when (NimMajor, NimMinor) < (1, 6):
                    # See https://github.com/nim-lang/Nim/issues/15215
                    if socket.isSsl():
                        socket.connect(address = $address, port = Port(port))
                    else:
                        socket.connect(address = $address, port = Port(port), timeout = timeout)
                else:
                    socket.connect(address = $address, port = Port(port), timeout = timeout)
            except Exception as e:
                socket.closeFd()
                raise (ref ConnectError)(msg: e.msg, url: thisUrl, parent: e)

        if uri.scheme == "https":
            wrapConnectedSocket(
                ctx = sslContext,
                socket = socket,
                handshake = handshakeAsClient,
                hostname = uri.hostname
            )

        # Send request
        await socket.send(data = data)

        # Start reading headers
        var chunks: string

        while not anyIt(["\r\n\r\n", "\n\n"], it in chunks):
            when self is AsyncUnalix:
                let future: Future[string] = socket.recv(size = 100)
                await future or sleepAsync(ms = timeout)

                if not future.finished():
                    future.fail(error = (ref TimeoutError)(msg: "Call to 'recv' timed out."))

                if future.failed():
                    socket.closeFd()

                    let e: ref Exception = future.readError()
                    raise (ref ReadError)(msg: e.msg, url: thisUrl, parent: e)

                let data: string = future.read()
            else:
                let data: string = (
                    try:
                        socket.recv(size = 100, timeout = timeout)
                    except Exception as e:
                        socket.closeFd()
                        raise (ref ReadError)(msg: e.msg, url: thisUrl, parent: e)
                )

            if len(data) < 1:
                break

            chunks.add(y = data)

        # Parse headers
        var response: Response = (
            try:
                parseHeaders(chunks = chunks)
            except RemoteProtocolError as e:
                socket.closeFd()

                e.url = thisUrl
                raise e
        )

        # Handle HTTP redirects
        var location: string

        if response.statusCode.is3xx() and response.headers.hasKey(key = "Location"):
            location = response.headers["Location"].toString()
        elif response.statusCode.is2xx() and response.headers.hasKey(key = "Content-Location"):
            location = response.headers["Content-Location"].toString()

        if not location.isEmptyOrWhitespace():
            socket.closeFd()

            location = location.replace(sub = " ", by = "%20")

            if not (location.startsWith(prefix = "https://") or location.startsWith(prefix = "http://")):
                if location.startsWith(prefix = "//"):
                    location = "$1://$2" % [uri.scheme, location.replace(sub = peg"^ '/' *", by = "")]
                elif location.startsWith(prefix = '/'):
                    location = "$1://$2$3" % [uri.scheme, hostname, location]
                else:
                    location = "$1://$2$3$4" % [
                        uri.scheme,
                        hostname,
                        (
                            if uri.path == "/":
                                uri.path
                            else:
                                parentDir(path = uri.path)
                        ),
                        location
                    ]

            # Avoid redirect loops
            if location == thisUrl:
                return thisUrl

            # Strip tracking fields from the redirect URL
            thisUrl = clearUrl(
                url = location,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked,
                stripDuplicates = stripDuplicates,
                stripEmpty = stripEmpty
            )

            inc currentRedirects

            if currentRedirects > maxRedirects:
                raise (ref TooManyRedirectsError)(msg: "Exceeded maximum allowed redirects", url: thisUrl)

            continue

        if parseDocuments:
            while len(response.body) <= DEFAULT_MAX_FETCH_SIZE:
                when self is AsyncUnalix:
                    let future: Future[string] = socket.recv(size = 100)
                    await future or sleepAsync(ms = timeout)

                    if not future.finished():
                        future.fail(error = (ref TimeoutError)(msg: "Call to 'recv' timed out."))

                    if future.failed():
                        socket.closeFd()

                        let e: ref Exception = future.readError()
                        raise (ref ReadError)(msg: e.msg, url: thisUrl, parent: e)

                    let data: string = future.read()
                else:
                    let data: string = (
                        try:
                            socket.recv(size = 100, timeout = timeout)
                        except Exception as e:
                            socket.closeFd()
                            raise (ref ReadError)(msg: e.msg, url: thisUrl, parent: e)
                    )

                if len(data) < 1:
                    break

                response.body.add(y = data)

            socket.closeFd()

            if response.headers.hasKey(key = "Content-Length"):
                # If there is a "Content-Length" header field in the response we will check if it matches
                # the length of the response body
                let contentLength: int = response.headers["Content-Length"].toString().parseInt()

                if contentLength <= DEFAULT_MAX_FETCH_SIZE and len(response.body) != contentLength:
                    raise (ref RemoteProtocolError)(msg: "Server closed connection without sending complete message body (received $1 bytes, expected $2)" % [$len(response.body), $contentLength], url: thisUrl)

            var redirectMatches: bool = false

            block loop:
                for redirect in redirectsTable:
                    if thisUrl.match(pattern = redirect["urlPattern"].regexVal):
                        for ruleset in redirect["rules"].seqRegexVal:
                            var matches: array[0..1, string]

                            if response.body.find(pattern = ruleset, matches = matches) > -1:
                                (location, redirectMatches) = (matches[0], true)
                                break loop

            if redirectMatches:
                thisUrl = clearUrl(
                    url = requoteUri(uri = unescape(s = location)),
                    ignoreReferralMarketing = ignoreReferralMarketing,
                    ignoreRules = ignoreRules,
                    ignoreExceptions = ignoreExceptions,
                    ignoreRawRules = ignoreRawRules,
                    ignoreRedirections = ignoreRedirections,
                    skipBlocked = skipBlocked,
                    stripDuplicates = stripDuplicates,
                    stripEmpty = stripEmpty
                )

                inc currentRedirects

                if currentRedirects > maxRedirects:
                    raise (ref TooManyRedirectsError)(msg: "Exceeded maximum allowed redirects", url: thisUrl)

                continue
        else:
            socket.closeFd()

        return thisUrl
