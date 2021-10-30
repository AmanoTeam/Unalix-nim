import strutils
import uri
import sugar
import strformat

const
    unreservedCharacters: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" &
        "abcdefghijklmnopqrstuvwxyz" & 
        "0123456789" &
        "-._~"
    safeWithPercent: string = "!#$%&'()*+,/:;=?@[]~"
    safeWithoutPercent: string = "!#$&'()*+,/:;=?@[]~"
    htmlEscapeSequences: array[0..3, (string, string)] = [
        ("&lt;", "<"),
        ("&gt;", ">"),
        ("&amp;", "&"),
        ("&quot;", "\"")
    ]


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

        params.add(if value.isEmptyOrWhitespace(): key else: &"{key}={value}")
        names.add(key)

        result = params.join(sep = "&")


proc htmlUnescape*(s: string): string =
    # Unescape HTML sequences to it's UTF-8 representation
    result = multiReplace(
        s = s,
        replacements = htmlEscapeSequences
    )
