import strformat

const
    UNALIX_VERSION*: string = "0.8"
    UNALIX_REPOSITORY*: string = "https://github.com/AmanoTeam/Unalix-nim"

const
    DEFAULT_HTTP_HEADERS*: seq[(string, string)] = @[
        ("Accept", "*/*"),
        ("Accept-Encoding", "identity"),
        ("Connection", "close"),
        ("User-Agent", &"Unalix/{UNALIX_VERSION} (+{UNALIX_REPOSITORY})")
    ]
    DEFAULT_MAX_REDIRECTS*: int = 13
    DEFAULT_TIMEOUT*: int = 3000