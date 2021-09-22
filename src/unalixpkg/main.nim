import parseopt
import strformat
import browsers
import httpcore
import net
import strutils
import times

import ./core
import ./exceptions
import ./config

const helpMessage: string = &"""
usage: unalix [-h] [-v] -u URL
              [--ignore-referral]
              [--ignore-generic]
              [--ignore-exceptions]
              [--ignore-raw]
              [--ignore-redirections]
              [--skip-blocked]
              [--strip-duplicates]
              [--strip-empty]
              [--parse-documents] [-s]
              [-l]
              [--http-method METHOD]
              [--http-max-redirects MAX_REDIRECTS]
              [--http-max-timeout MAX_TIMEOUT]
              [--http-max-fetch-size MAX_FETCH_SIZE]
              [--http-max-retries MAX_RETRIES]
              [--disable-certificate-validation]

Unalix is a small, dependency-free, fast
Nim package and CLI tool for removing
tracking fields from URLs.

optional arguments:
  -h, --help        show this help
                    message and exit
  -v, --version     show version number
                    and exit
  -u URL, --url URL
                    HTTP URL you want to
                    unshort or remove
                    tracking fields
                    from. [default: read
                    from stdin]
  --ignore-referral
                    Don't strip referral
                    marketing fields.
  --ignore-generic  Ignore generic
                    rules.
  --ignore-exceptions
                    Ignore rule
                    exceptions.
  --ignore-raw      Ignore raw rules.
  --ignore-redirections
                    Ignore redirection
                    rules.
  --skip-blocked    Ignore rule
                    processing for
                    blocked URLs.
  --strip-duplicates
                    Strip fields with
                    duplicate names.
                    (might break the
                    URL!)
  --strip-empty     Strip fields with
                    empty values. (might
                    break the URL!)
  --parse-documents
                    Look for redirect
                    URLs in the response
                    body when there is
                    no HTTP redirect to
                    follow.
  -s, --unshort     Unshort the given
                    URL (HTTP requests
                    will be made).
  -l, --launch      Launch URL(s) with
                    default browser.

HTTP settings:
  Arguments from this group only takes
  effect when --unshort is set.

  --http-method METHOD
                    Default HTTP method
                    for requests.
                    [default: GET]
  --http-max-redirects MAX_REDIRECTS
                    Max number of HTTP
                    redirects to follow
                    before raising an
                    exception. [default:
                    {defaultHttpMaxRedirects}]
  --http-max-timeout MAX_TIMEOUT
                    Max number of
                    seconds to wait for
                    a response before
                    raising an
                    exception. [default:
                    {initDuration(milliseconds = defaultHttpTimeout).inSeconds}]
  --http-max-fetch-size MAX_FETCH_SIZE
                    Max number of bytes
                    to fetch from
                    responses body. Only
                    takes effect when
                    --parse-documents is
                    set. [default:
                    {defaultHttpMaxFetchSize}]
  --http-max-retries MAX_RETRIES
                    Max number of times
                    to retry on
                    connection errors.
                    [default: {defaultHttpMaxRetries}]
  --disable-certificate-validation
                    Disable TLS
                    certificates
                    validation

Note, options that take an argument
require a colon. E.g. -u:URL.
"""

const
    repository: string = staticExec("git config --get remote.origin.url")
    commitHash: string = staticExec("git rev-parse --short HEAD")
    versionInfo: string = &"Unalix v{UNALIX_VERSION} ({repository}@{commitHash})" &
        "\n" &
        &"Compiled for {hostOS} ({hostCPU}) using Nim {NimVersion}" &
        &"({CompileDate}, {CompileTime})" &
        "\n"
    longNoVal: seq[string] = @[
        "ignore-referral",
        "ignore-generic",
        "ignore-exceptions",
        "ignore-raw",
        "ignore-redirections",
        "skip-blocked",
        "strip-duplicates",
        "strip-empty",
        "parse-documents",
        "launch",
        "help",
        "version",
        "unshort",
        "http-method",
        "http-max-redirects",
        "http-max-timeout",
        "http-max-fetch-size",
        "http-max-retries",
        "disable-certificate-validation",
    ]
    shortNoVal: set[char] = {
        'h',
        'v',
        'l',
        's'
    }

var
    url, newUrl, argument: string
    ignoreReferralMarketing, ignoreRules, ignoreExceptions, ignoreRawRules: bool
    ignoreRedirections, skipBlocked, stripDuplicates, stripEmpty: bool
    launch, unshort, parseDocuments: bool
    parser: OptParser
    httpMethod: HttpMethod = defaultHttpMethod
    httpMaxRedirects: int = defaultHttpMaxRedirects
    httpTimeout: int = defaultHttpTimeout
    httpMaxFetchSize: int = defaultHttpMaxFetchSize
    httpMaxRetries: int = defaultHttpMaxRetries
    sslContext: SslContext = newContext()

proc signalHandler() {.noconv.} =
    stdout.write("\n")
    quit(0)

setControlCHook(signalHandler)

parser = initOptParser(longNoVal = longNoVal, shortNoVal = shortNoVal)

while true:
    parser.next()

    case parser.kind
    of cmdEnd:
        break
    of cmdShortOption, cmdLongOption:
        case parser.key
        of "version", "v":
            stdout.write(versionInfo)
            quit(0)
        of "help", "h":
            stdout.write(helpMessage)
            quit(0)
        of "url":
            if parser.val == "":
                stderr.write("unalix: missing required value for argument: --url\n")
                quit(1)
            else:
                url = parser.val
        of "u":
            if parser.val == "":
                stderr.write("unalix: missing required value for argument: -u\n")
                quit(1)
            else:
                url = parser.val
        of "ignore-referral":
            ignoreReferralMarketing = true
        of "ignore-generic":
            ignoreRules = true
        of "ignore-exceptions":
            ignoreExceptions = true
        of "ignore-raw":
            ignoreRawRules = true
        of "ignore-redirections":
            ignoreRedirections = true
        of "skip-blocked":
            skipBlocked = true
        of "strip-duplicates":
            stripDuplicates = true
        of "strip-empty":
            stripEmpty = true
        of "launch", "l":
            launch = true
        of "unshort", "s":
            unshort = true
        of "parse-documents":
            parseDocuments = true
        of "http-method":
            case parser.val:
            of "HEAD":
                httpMethod = HttpHead
            of "GET":
                httpMethod = HttpGet
            of "PUT":
                httpMethod = HttpPut
            of "DELETE":
                httpMethod = HttpDelete
            of "TRACE":
                httpMethod = HttpTrace
            of "OPTIONS":
                httpMethod = HttpOptions
            of "CONNECT":
                httpMethod = HttpConnect
            of "PATCH":
                httpMethod = HttpPatch
            else:
                stderr.write(&"unalix: unrecognized HTTP method: {parser.val}\n")
                quit(1)
        of "http-max-redirects":
            try:
                httpMaxRedirects = parseInt(s = parser.val)
            except ValueError:
                stderr.write(&"unalix: invalid numeric literal: {parser.val}\n")
                quit(1)
        of "http-max-timeout":
            try:
                httpTimeout = parseInt(s = parser.val)
            except ValueError:
                stderr.write(&"unalix: invalid numeric literal: {parser.val}\n")
                quit(1)
            httpTimeout = int(inMilliseconds(dur = initDuration(seconds = httpTimeout)))
        of "http-max-fetch-size":
            try:
                httpMaxFetchSize = parseInt(s = parser.val)
            except ValueError:
                stderr.write(&"unalix: invalid numeric literal: {parser.val}\n")
                quit(1)
        of "http-max-retries":
            try:
                httpMaxRetries = parseInt(s = parser.val)
            except ValueError:
                stderr.write(&"unalix: invalid numeric literal: {parser.val}\n")
                quit(1)
        of "disable-certificate-validation":
            sslContext = newContext(verifyMode = CVerifyNone)
        else:
            argument = if len(parser.key) > 1: fmt("--{parser.key}") else: fmt("-{parser.key}")
            stderr.write(&"unalix: unrecognized argument: {argument}\n")
            quit(1)
    else:
        discard

if url == "":
    for stdinUrl in stdin.lines:
        if unshort:
            newUrl = unshortUrl(
                url = stdinUrl,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked,
                stripEmpty = stripEmpty,
                stripDuplicates = stripDuplicates,
                parseDocuments = parseDocuments,
                httpMethod = httpMethod,
                httpMaxRedirects = httpMaxRedirects,
                httpTimeout = httpTimeout,
                httpMaxFetchSize = httpMaxFetchSize,
                httpMaxRetries = httpMaxRetries,
                sslContext = sslContext
            )
        else:
            newUrl = clearUrl(
                url = stdinUrl,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked,
                stripEmpty = stripEmpty,
                stripDuplicates = stripDuplicates
            )
        if launch:
            stdout.write(&"Launching {newUrl}\n")
        else:
            stdout.write(&"{newUrl}\n")
else:
    if unshort:
        try:
            newUrl = unshortUrl(
                url = url,
                ignoreReferralMarketing = ignoreReferralMarketing,
                ignoreRules = ignoreRules,
                ignoreExceptions = ignoreExceptions,
                ignoreRawRules = ignoreRawRules,
                ignoreRedirections = ignoreRedirections,
                skipBlocked = skipBlocked,
                stripEmpty = stripEmpty,
                stripDuplicates = stripDuplicates,
                parseDocuments = parseDocuments,
                httpMethod = httpMethod,
                httpMaxRedirects = httpMaxRedirects,
                httpTimeout = httpTimeout,
                httpMaxFetchSize = httpMaxFetchSize,
                httpMaxRetries = httpMaxRetries,
                sslContext = sslContext
            )
        except ConnectError as e:
            stderr.write(&"unalix: exception: {e.msg}\n")
            newUrl = e.url
    else:
        newUrl = clearUrl(
            url = url,
            ignoreReferralMarketing = ignoreReferralMarketing,
            ignoreRules = ignoreRules,
            ignoreExceptions = ignoreExceptions,
            ignoreRawRules = ignoreRawRules,
            ignoreRedirections = ignoreRedirections,
            skipBlocked = skipBlocked,
            stripEmpty = stripEmpty,
            stripDuplicates = stripDuplicates
        )
    if launch:
        stderr.write(&"Launching {newUrl}\n")
        openDefaultBrowser(newUrl)
    else:
        stdout.write(&"{newUrl}\n")
