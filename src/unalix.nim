import std/asyncdispatch
import std/net

import ./unalixpkg/url_cleaner
import ./unalixpkg/url_unshort
import ./unalixpkg/exceptions
import ./unalixpkg/types
import ./unalixpkg/config

proc unshortUrl*(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false,
    parseDocuments: bool = false,
    timeout: int = DEFAULT_TIMEOUT,
    headers: seq[(string, string)] = DEFAULT_HTTP_HEADERS,
    maxRedirects: int = DEFAULT_MAX_REDIRECTS,
    sslContext: SslContext = newContext()
): string =
    
    let obj: SyncUnalix = SyncUnalix()
    
    result = obj.unshortUrl(
        url = url,
        ignoreReferralMarketing = ignoreReferralMarketing,
        ignoreRules = ignoreRules,
        ignoreExceptions = ignoreExceptions,
        ignoreRawRules = ignoreRawRules,
        ignoreRedirections = ignoreRedirections,
        skipBlocked = skipBlocked,
        stripDuplicates = stripDuplicates,
        stripEmpty = stripEmpty,
        parseDocuments = parseDocuments,
        timeout = timeout,
        headers = headers,
        maxRedirects = maxRedirects,
        sslContext = sslContext
    )


proc aunshortUrl*(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false,
    parseDocuments: bool = false,
    timeout: int = DEFAULT_TIMEOUT,
    headers: seq[(string, string)] = DEFAULT_HTTP_HEADERS,
    maxRedirects: int = DEFAULT_MAX_REDIRECTS,
    sslContext: SslContext = newContext()
): Future[string] {.async, gcsafe.} =
    
    let obj: AsyncUnalix = AsyncUnalix()
    
    result = await obj.unshortUrl(
        url = url,
        ignoreReferralMarketing = ignoreReferralMarketing,
        ignoreRules = ignoreRules,
        ignoreExceptions = ignoreExceptions,
        ignoreRawRules = ignoreRawRules,
        ignoreRedirections = ignoreRedirections,
        skipBlocked = skipBlocked,
        stripDuplicates = stripDuplicates,
        stripEmpty = stripEmpty,
        parseDocuments = parseDocuments,
        timeout = timeout,
        headers = headers,
        maxRedirects = maxRedirects,
        sslContext = sslContext
    )

export clearUrl

export UnsupportedProtocolError
export ReadError
export TooManyRedirectsError
export ConnectError
