import httpclient

const (output, exit_code) = gorgeEx("nimble path unalix")

when exit_code != 0:
  const fatal: string =
    """
    Could not get library path.
    """"
  stderr.write(fatal)

const library_path = output

const rules_list = [
    library_path & "/package_data/data.min.json", 
    library_path & "/package_data/unalix-data.min.json"
]

const replacements = [
    (r"(?:%26)+", "%26"),
    (r"&+", "&"),
    (r"(?:%3[fF])+", "%3f"),
    (r"(?:%3[fF]|\?|%23|#|&)+$", ""),
    (r"\?&",  "?"),
    (r"%3[fF]%26", "%3f")
]

let headers = newHttpHeaders({
    "Connection": "close",
    "Cache-Control": "no-cache, no-store",
    "User-Agent": "Unalix/0.1 (+https://github.com/AmanoTeam/Unalix-nim)"
})

let client = newHttpClient(headers=headers, maxRedirects=0)
