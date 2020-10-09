import re
import json
import uri

const (output, exit_code) = gorgeEx("nimble path unalix")

when exit_code != 0:
  fatal:
    """
    Could not get library path.
    """"

const library_path = output

const rules_list = [
    library_path & "/package_data/data.min.json", 
    library_path & "/package_data/unalix-data.min.json"
]

# Some of these fields may remain in the URL
# after tracking"s fields removal, so we need to
# remove/replace them
const replacements = [
    (r"(?:%26)+", "%26"),
    (r"&+", "&"),
    (r"(?:%3[fF])+", "%3f"),
    (r"(?:%3[fF]|\?|%23|#|&)+$", ""),
    (r"\?&",  "?"),
    (r"%3[fF]%26", "%3f")
]

var rules = %*[]

for file in rules_list:
  var file_object = open(file, fmRead)
  var json_node = parseJson(readAll(file_object))
  rules.add(json_node)

proc parse_rules(
    url: string,
    allow_referral: bool = false,
    ignore_rules: bool = false,
    ignore_exceptions: bool = false,
    ignore_raw: bool = false,
    ignore_redirections: bool = false,
    ignore_domain_blocking: bool = false
): string =
    
    var
      result: string
      skip_provider: bool
      original_url: string
    
    for rule in rules:
        for provider in keys(rule["providers"]):
            (original_url, skip_provider, result) = (url, false, url)
            if not ( ignore_domain_blocking and rule["providers"][provider]["completeProvider"].getBool() ):
                if match(result, re(rule["providers"][provider]["urlPattern"].getStr())):
                    if not ignore_exceptions:
                        for exception in rule["providers"][provider]["exceptions"]:
                            if match(result, re(exception.getStr())):
                                skip_provider = true
                                break
                    if not skip_provider:
                        if not ignore_redirections:
                            for redirection in rule["providers"][provider]["redirections"]:
                                result = replacef(result, re(redirection.getStr() & ".*"), "$1")
                            if result != original_url:
                                result = decodeUrl(result)
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

export parse_rules