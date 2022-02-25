import std/asyncdispatch
import std/net

import ./unalixpkg/url_cleaner
import ./unalixpkg/url_unshort
import ./unalixpkg/exceptions
import ./unalixpkg/types
import ./unalixpkg/config

const
    syncUnalix: SyncUnalix = SyncUnalix()
    asyncUnalix: AsyncUnalix = AsyncUnalix()

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
    sslContext: SslContext = nil
): string =

    result = syncUnalix.unshortUrl(
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
    sslContext: SslContext = nil
): Future[string] {.async, gcsafe.} =

    result = await asyncUnalix.unshortUrl(
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
export exceptions