import re
import os
import uri
import strutils
import httpclient

include ../config/http
import ./url_cleaner

proc unshortUrl(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false
): string =
    ##
    ##    This method implements a simple HTTP 1.1 client, mainly used to follow HTTP redirects.
    ##
    ##    We ensure that all redirect URLs are cleaned before following them.
    ##
    ##    Parameters:
    ##
    ##        url (`string`):
    ##            A string representing an HTTP URL.
    ##
    ##        ignoreReferralMarketing (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not remove referral marketing fields from the URL query. Defaults to `false`.
    ##
    ##            This is similar to ClearURLs"s **"Allow referral marketing"** option.
    ##
    ##        ignoreRules (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not remove tracking fields from the given URL. Defaults to `false`.
    ##
    ##        ignoreExceptions (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore exceptions for the given URL. Defaults to `false`.
    ##
    ##        ignoreRawRules (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore raw rules for the given URL. Defaults to `false`.
    ##
    ##        ignoreRedirections (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore redirection rules for the given URL. Defaults to `false`.
    ##
    ##        skipBlocked (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not process rules for blocked URLs. Defaults to `false`.
    ##
    ##            This is similar to ClearURLs **"Allow domain blocking"** option, but instead of blocking access to the URL,
    ##            we just ignore all rulesets where it"s blocked.
    ##
    ##    Usage examples:
    ##
    ##      1st example
    ##
    ##          .. code-block::
    ##            from unalix import unshortUrl
    ##
    ##            var url = "https://deezer.com/track/891177062?utm_source=deezer"
    ##
    ##            doAssert unshortUrl(url) == "https://deezer.com/track/891177062"
    ##
    ##      2nd example
    ##
    ##          .. code-block::
    ##            from unalix import unshortUrl
    ##
    ##            var url = "https://bitly.is/Pricing-Pop-Up"
    ##
    ##            doAssert unshortUrl(url) == "https://bitly.com/pages/pricing"
    ##

    var
        response: Response
        redirectLocation, parsedUrl: string
        uri: Uri

    var totalRedirects = 0

    let client: HttpClient = newHttpClient(
        timeout = httpTimeout,
        headers = newHttpHeaders(httpHeaders),
        maxRedirects = 0
    )

    parsedUrl = url

    while true:
        uri = parseUri(parsedUrl) 

        result = parsedUrl

        response = client.request(url = parsedUrl, httpMethod = HttpHead)

        if response.headers.hasKey("Location"):
            redirectLocation = response.headers["Location"]
        elif response.headers.hasKey("Content-Location"):
            redirectLocation = response.headers["Content-Location"]

        if redirectLocation != "":
            redirectLocation = redirectLocation.replace(" ", "%20")

            if not redirectLocation.startsWith(re"^https?://"):
                if redirectLocation.startsWith("//"):
                    redirectLocation = uri.scheme & "://" & replacef(redirectLocation, re"^/*", "") 
                elif redirectLocation.startsWith("/"):
                    redirectLocation = uri.scheme & "://" & uri.hostname & redirectLocation
                else:
                    redirectLocation = uri.scheme & "://" & uri.hostname & (if uri.path != "/": parentDir(uri.path) else: uri.path) & redirectLocation

            # Redirect loop
            if redirectLocation == parsedUrl:
                break

            totalRedirects += 1

            # Strip tracking fields from the redirect URL
            parsedUrl = clearUrl(
                url = redirectLocation,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked
            )

            # Response body is ignored in redirects
            client.close()

            if totalRedirects > httpMaxRedirects:
                raise newException(CatchableError, "Exceeded maximum allowed redirects")

            continue

        break

export unshortUrl
