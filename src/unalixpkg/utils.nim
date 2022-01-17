import std/strutils
import std/uri
import std/sugar
import std/strformat
import std/re
import std/htmlparser

const
    unreservedCharacters: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" &
        "abcdefghijklmnopqrstuvwxyz" & 
        "0123456789" &
        "-._~"
    safeWithPercent: string = "!#$%&'()*+,/:;=?@[]~"
    safeWithoutPercent: string = "!#$&'()*+,/:;=?@[]~"


# Source: https://github.com/psf/requests/blob/v2.24.0/requests/utils.py#L570
proc unquoteUnreserved(uri: string): string =
    ## Un-escape any percent-escape sequences in a URI that are unreserved
    ## characters. This leaves all reserved, illegal and non-ASCII bytes encoded.

    var
        hexadecimalString: string
        hexadecimalInt: int
        character: char
        parts: seq[string]

    parts = uri.split(sep = "%")

    for index in 1 ..< len(parts):
        hexadecimalString = parts[index][0 .. 1]

        if len(hexadecimalString) == 2 and hexadecimalString[0].isAlphaNumeric():
            hexadecimalInt = fromHex[int](s = hexadecimalString)
            character = chr(u = hexadecimalInt)

            if character in unreservedCharacters:
                parts[index] = character & parts[index][2 .. ^1]
            else:
                parts[index] = "%" & parts[index]
        else:
            parts[index] = "%" & parts[index]

    result = parts.join()


# Source: https://github.com/psf/requests/blob/v2.24.0/requests/utils.py#L594
proc requoteUri*(uri: string): string =
    ## This function passes the given URI through an unquote/quote cycle to
    ## ensure that it is fully and consistently quoted.

    var quotedUri: string

    try:
        ## Unquote only the unreserved characters
        ## Then quote only illegal characters (do not quote reserved,
        ## unreserved, or '%')
        for character in unquoteUnreserved(uri = uri):
            if character in unreservedCharacters & safeWithPercent:
                quotedUri.add(y = character)
            else:
                quotedUri.add(
                    y = encodeUrl(s = $character, usePlus = false)
                )
    except:
        ## We couldn't unquote the given URI, so let"s try quoting it, but
        ## there may be unquoted "%"s in the URI. We need to make sure they're
        ## properly quoted so they do not cause issues elsewhere.
        for character in uri:
            if character in unreservedCharacters & safeWithoutPercent:
                quotedUri.add(y = character)
            else:
                quotedUri.add(
                    y = encodeUrl(s = $character, usePlus = false)
                )

    result = quotedUri

proc filterQuery*(
    query: string,
    stripEmpty: bool = false,
    stripDuplicates: bool = false
): string =

    var
        params, names: seq[string] = newSeq[string]()

    var
        key, value: string
        values, parts: seq[string]

    for param in query.split(sep = '&'):
        # Ignore empty fields
        if param.isEmptyOrWhitespace():
            continue

        parts = param.split(sep = '=')

        key = parts[0]
        values = block: collect newSeq: (for index in 1 ..< len(parts): parts[index])

        value = values.join(sep = "%3D")
        value = value.replace(sub = "?", by = "%3F")

        # Ignore field with empty value
        if stripEmpty and value.isEmptyOrWhitespace():
            continue

        # Ignore field with duplicate name
        if stripDuplicates and key in names:
            continue

        params.add(if not value.isEmptyOrWhitespace() or "=" in param: &"{key}={value}" else: key)
        names.add(key)

        result = params.join(sep = "&")

proc unescape*(s: string): string =
    ## Convert all named and numeric character references (e.g. `&gt;`, `&#62;`,
    ## `&x3e;`) in the string `s` to the corresponding unicode characters.
    ## This function uses the rules defined by the HTML 5 standard
    ## for both valid and invalid character references, and the list of
    ## HTML 5 named character references defined in `html.entities.html5`.
    
    if "&" notin s:
        return s
    
    var replacements: seq[(string, string)] = newSeq[(string, string)]()
    var matches: seq[string] = newSeq[string]()
    
    for match in findAll(s = s, pattern = re"&(?:#[0-9]+;?|#[xX][0-9a-fA-F]+;?|[^\t\n\f <&#;]{1,32};?)"):
        if match in matches:
            continue
        
        var entity: string = match
        
        entity.removePrefix(c = '&')
        entity.removeSuffix(c = ';')
        
        let utf8Entity: string = entityToUtf8(entity = entity)
        
        if utf8Entity != "":
            replacements.add((match, utf8Entity))
            matches.add(match)

    result = multiReplace(
        s = s,
        replacements = replacements
    )
