const
    UNALIX_VERSION*: string = "0.5.1"
    UNALIX_REPOSITORY*: string = "https://github.com/AmanoTeam/Unalix-nim"

const
    HTTP_MAX_REDIRECTS*: int = 13
    HTTP_CONNECT_TIMEOUT*: int = 3000
    HTTP_READ_TIMEOUT*: int = 3000
    HTTP_READ_CHUNK_SIZE*: int = 1024
    HTTP_DOH_URL*: string = "https://cloudflare-dns.com/dns-query"
    HTTP_DOH_ADDRESS*: string = "1.1.1.1"
    HTTP_DOH_PORT*: int = 443
    HTTP_HEADERS*: seq[(string, string)] = @[
        ("Accept", "*/*"),
        ("Accept-Encoding", "identity"),
        ("Connection", "close"),
        ("User-Agent", "Unalix/" & UNALIX_VERSION & " (+" & UNALIX_REPOSITORY & ")")
    ]
    DOH_HEADERS*: seq[(string, string)] = @[
        ("Accept", "application/dns-json")
    ]
