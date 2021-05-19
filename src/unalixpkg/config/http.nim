const httpHeaders: array[0..3, (string, string)] = [
    ("Accept", "*/*"),
    ("Accept-Encoding", "identity"),
    ("Connection", "close"),
    ("User-Agent", "Unalix/0.1 (+https://github.com/AmanoTeam/Unalix-nim)")
]

const httpTimeout: int = 8 * 1000

const httpMaxRedirects: int = 13
