import std/strformat
import std/httpcore

const
    UNALIX_VERSION*: string = "0.7"
    UNALIX_REPOSITORY*: string = "https://github.com/AmanoTeam/Unalix-nim"

const
    defaultHttpHeaders*: seq[(string, string)] = @[
        ("Accept", "*/*"),
        ("Accept-Encoding", "identity"),
        ("Connection", "close"),
        ("User-Agent", &"Unalix/{UNALIX_VERSION} (+{UNALIX_REPOSITORY})")
    ]
    defaultHttpTimeout*: int = 3000
    defaultHttpMaxRedirects*: int = 13
    defaultHttpMaxRetries*: int = 0
    defaultHttpMaxFetchSize*: int = 1024 * 1024
    defaultHttpMethod*: HttpMethod = HttpGet
    defaultHttpStatusRetry*: seq[HttpCode] = @[
        Http429,
        Http500,
        Http502,
        Http503,
        Http504
    ]
