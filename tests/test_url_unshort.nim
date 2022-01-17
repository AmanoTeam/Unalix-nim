import std/asynchttpserver
import std/asyncdispatch
import std/asyncnet
import std/strformat

import ../src/unalix

# Server section
const
    address: string = "127.0.0.1"
    port: int = 55555

let server: AsyncHttpServer = newAsyncHttpServer()

proc callback(request: Request): Future[void] {.async, gcsafe.} =

    case request.url.path
    of  "/ok":
        await request.client.send(data = "HTTP/1.1 200 OK\r\n\r\n")
    of "/redirect-to-tracking":
        await request.client.send(data = "HTTP/1.1 301 Moved Permanently\r\n")
        await request.client.send(data = &"Location: http://{address}:{port}/ok?utm_source=127.0.0.1\r\n\r\n")
    of "/absolute-redirect":
        await request.client.send(data = "HTTP/1.1 301 Moved Permanently\r\n")
        await request.client.send(data = &"Location: http://{address}:{port}/redirect-to-tracking\r\n\r\n")
    of "/relative-redirect":
        await request.client.send(data = "HTTP/1.1 301 Moved Permanently\r\n")
        await request.client.send(data = "Location: ok\r\n\r\n")
    of "/root-redirect":
        await request.client.send(data = "HTTP/1.1 301 Moved Permanently\r\n")
        await request.client.send(data = "Location: /redirect-to-tracking\r\n\r\n")
    of "/i-dont-know-its-name-redirect":
        await request.client.send(data = "HTTP/1.1 301 Moved Permanently\r\n")
        await request.client.send(data = &"Location: //{address}:{port}/redirect-to-tracking\r\n\r\n")
    else:
        discard
    
    request.client.close()

asyncCheck server.serve(
    port = Port(port),
    callback = callback,
    address = address
)

proc main: Future[void] {.async, gcsafe.} =

    doAssert (await aunshortUrl(url = &"http://{address}:{port}/absolute-redirect")) == &"http://{address}:{port}/ok"

    doAssert (await aunshortUrl(url = &"http://{address}:{port}/relative-redirect")) == &"http://{address}:{port}/ok"

    doAssert (await aunshortUrl(url = &"http://{address}:{port}/root-redirect")) == &"http://{address}:{port}/ok"

    doAssert (await aunshortUrl(url = &"http://{address}:{port}/i-dont-know-its-name-redirect")) == &"http://{address}:{port}/ok"

waitFor main()

try:
    server.close()
except OSError:
    discard