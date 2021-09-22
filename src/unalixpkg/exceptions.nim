type
    ConnectError* = ref object of CatchableError
        url*: string
    UnsupportedProtocolError* {.final.} = ref object of ConnectError
    ReadError* {.final.} = ref object of ConnectError
    TooManyRedirectsError* {.final.} = ref object of ConnectError
    MaxRetriesError* {.final.} = ref object of ConnectError
