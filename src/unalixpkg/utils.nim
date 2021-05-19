import strutils
import uri
import sugar
import strformat

# The unreserved URI characters (RFC 3986)
const unreservedCharacters: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" &
    "abcdefghijklmnopqrstuvwxyz" & 
    "0123456789" &
    "-._~"

const safeWithPercent: string = "!#$%&'()*+,/:;=?@[]~"
const safeWithoutPercent: string = "!#$&'()*+,/:;=?@[]~"

# Source: https://github.com/psf/requests/blob/v2.24.0/requests/utils.py#L570
proc unquoteUnreserved(uri: string): string =
    ## Un-escape any percent-escape sequences in a URI that are unreserved
    ## characters. This leaves all reserved, illegal and non-ASCII bytes encoded.

    var
        hexadecimalString: string
        hexadecimalInt: int
        character: char
        parts: seq[string]

    parts = uri.split("%")

    for index in 1 ..< len(parts):
        hexadecimalString = parts[index][0 .. 1]

        if len(hexadecimalString) == 2 and isAlphaNumeric(hexadecimalString[0]):
            hexadecimalInt = fromHex[int](hexadecimalString)
            character = chr(hexadecimalInt)

            if character in unreservedCharacters:
                parts[index] = character & parts[index][2 .. ^1]
            else:
                parts[index] = "%" & parts[index]
        else:
            parts[index] = "%" & parts[index]

    result = parts.join()


# Source: https://github.com/psf/requests/blob/v2.24.0/requests/utils.py#L594
proc requoteUri(uri: string): string =
    ## This function passes the given URI through an unquote/quote cycle to
    ## ensure that it is fully and consistently quoted.

    var quotedUri: string

    try:
        ## Unquote only the unreserved characters
        ## Then quote only illegal characters (do not quote reserved,
        ## unreserved, or '%')
        for character in unquoteUnreserved(uri):
            if character in unreservedCharacters & safeWithPercent:
                quotedUri.add(character)
            else:
                quotedUri.add(encodeUrl($character, usePlus = false))
    except ValueError:
        ## We couldn't unquote the given URI, so let"s try quoting it, but
        ## there may be unquoted "%"s in the URI. We need to make sure they're
        ## properly quoted so they do not cause issues elsewhere.
        for character in uri:
            if character in unreservedCharacters & safeWithoutPercent:
                quotedUri.add(character)
            else:
                quotedUri.add(encodeUrl($character, usePlus = false))

    result = quotedUri

proc filterQuery(
    query: string,
    stripEmpty: bool = false,
    stripDuplicates: bool = false
): string =

    var
        params, names = newSeq[string]()

    var
        key, value: string
        values, parts: seq[string]

    for param in query.split("&"):
        # Ignore empty fields
        if len(param) == 0:
            continue

        parts = param.split("=")

        key = parts[0]
        values = block: collect newSeq: (for index in 1 ..< len(parts): parts[index])

        value = values.join("%3D")

        # Ignore field with empty value
        if stripEmpty and len(value) == 0:
            continue

        # Ignore field with duplicate name
        if stripDuplicates and key in names:
            continue

        params.add(fmt"{key}={value}")
        names.add(key)

        result = params.join("&")


export requoteUri
export filterQuery

