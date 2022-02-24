type
    UnalixException* {.pure, inheritable.} = object of CatchableError
        url*: string
    ConnectError* {.final.} = object of UnalixException
    ResolverError* {.final.} = object of UnalixException
    UnsupportedProtocolError* {.final.} = object of UnalixException
    RemoteProtocolError* {.final.} = object of UnalixException
    ReadError* {.final.} = object of UnalixException
    SendError* {.final.} = object of UnalixException
    TooManyRedirectsError* {.final.} = object of UnalixException
