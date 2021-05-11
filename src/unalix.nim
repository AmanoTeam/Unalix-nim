include unalix/files
import re
import uri
import tables

proc isRedirect(response: Response): bool =

    if startsWith(response.status, re"30[12378]"):
      return true

proc handleRedirects(lastURL: string, response: Response): string =

    var
        absolute, relative: Uri
        location: string

    location = response.headers.getOrDefault"Location"

    if startsWith(location, re"https?://"):
        return location

    relative = parseUri(location)

    absolute = parseUri(lastURL)
    absolute.path = relative.path
    absolute.query = relative.query
    absolute.anchor = relative.anchor
    
    return $absolute

proc clearUrl(
    url: string,
    allow_referral: bool = false,
    ignore_rules: bool = false,
    ignore_exceptions: bool = false,
    ignore_raw: bool = false,
    ignore_redirections: bool = false,
    skip_blocked: bool = false
): string =
    
    var
      result: string
      skip_provider: bool
      original_url: string

    original_url = url
    result = url

    for rule in rules:
        for provider in keys(rule["providers"]):
            if skip_blocked and rule["providers"][provider]["completeProvider"].getBool():
                continue
            skip_provider = false
            if match(result, re(rule["providers"][provider]["urlPattern"].getStr())):
                if not ignore_exceptions:
                    for exception in rule["providers"][provider]["exceptions"]:
                        if match(result, re(exception.getStr())):
                            skip_provider = true
                            break
                if skip_provider:
                    continue
                if not ignore_redirections:
                    for redirection in rule["providers"][provider]["redirections"]:
                        result = replacef(result, re(redirection.getStr() & ".*"), "$1")
                    if result != original_url:
                        result = decodeUrl(result, decodePlus = false)
                if not ignore_rules:
                    for common in rule["providers"][provider]["rules"]:
                        result = replacef(result, re(r"(%26|&|%23|#|%3F|%3f|\?)" & common.getStr() & r"((\=|%3D|%3d)[^&]*)"), "$1")
                if not allow_referral:
                    for referral in rule["providers"][provider]["referralMarketing"]:
                        result = replacef(result, re(r"(%26|&|%23|#|%3F|%3f|\?)" & referral.getStr() & r"((\=|%3D|%3d)[^&]*)"), "$1")
                if not ignore_raw:
                    for raw in rule["providers"][provider]["rawRules"]:
                        result = replace(result, re(raw.getStr()))
                original_url = result
    
    for pattern in replacements:
        result = replace(result, re(pattern[0]), pattern[1])

    return result

proc unshortUrl(url: string): string =

    var
        cleanedUrl, redirectUrl: string
        response: Response

    cleanedUrl = clearUrl(url)

    while true:

        response = head(client, cleanedUrl)

        if isRedirect(response):
            redirectUrl = handleRedirects(cleanedUrl, response)
            cleanedUrl = clearUrl(redirectUrl)
        else:
            break

    return cleanedUrl

export clearUrl
export unshortUrl

when isMainModule:
  import os

  proc main() =
    const help = """
Usage: echo <url> | unalix [--unshort]

--unshort -s: also unshorts the given URLs, i.e., removes all redirects from the URLs (this will make network requests)
"""

    let args = commandLineParams()

    var unshort = false

    if args.len >= 1:
      if (args[0] == "-h" or args[0] == "--help"):
        stderr.write(help)
        quit(0)
      if (args[0] == "-s" or args[0] == "--unshort"):
        unshort = true

    for url in stdin.lines:
      var new_url = clearUrl(url)
      if unshort:
        new_url = clearUrl(unshortUrl(new_url))

      stdout.write(new_url & "\n")

  main()
