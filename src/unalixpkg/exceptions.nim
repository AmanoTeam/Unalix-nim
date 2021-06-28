type
    ConnectError = ref object of CatchableError
        url*: string
    UnsupportedProtocolError = ref object of ConnectError
    ReadError = ref object of ConnectError
    ResolverError = ref object of ConnectError
    TooManyRedirectsError = ref object of ConnectError

export UnsupportedProtocolError
export ReadError
export ResolverError
export TooManyRedirectsError
export ConnectError
