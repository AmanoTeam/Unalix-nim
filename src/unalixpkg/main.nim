import parseopt
import strformat
import browsers

import ./url_cleaner

const helpMessage: string = """
usage: unalix [--help] [--version] --url URL
              [--ignore-referral]
              [--ignore-rules]
              [--ignore-exceptions]
              [--ignore-raw-rules]
              [--ignore-redirections]
              [--skip-blocked]
              [--strip-duplicates]
              [--strip-empty]
              [--launch-in-browser]

Unalix is a small, dependency-free, fast
Nim package (and CLI tool) for removing
tracking fields from URLs.

optional arguments:
  --help            show this help
                    message and exit.
  --version         show version number
                    and exit.
  --url URL         HTTP URL you want to
                    remove tracking
                    fields from
                    (default: read from
                    stdin)
  --ignore-referral
                    instruct Unalix to
                    not remove referral
                    marketing fields
                    from the given URL.
  --ignore-rules    instruct Unalix to
                    not remove tracking
                    fields from the
                    given URL.
  --ignore-exceptions
                    instruct Unalix to
                    ignore exceptions
                    for the given URL.
  --ignore-raw-rules
                    instruct Unalix to
                    ignore raw rules for
                    the given URL.
  --ignore-redirections
                    instruct Unalix to
                    ignore redirection
                    rules for the given
                    URL.
  --skip-blocked    instruct Unalix to
                    not process rules
                    for blocked URLs.
  --strip-duplicates
                    instruct Unalix to
                    strip fields with
                    duplicate names.
  --strip-empty     instruct Unalix to
                    strip fields with
                    empty values.
  --launch-in-browser
                    launch URL with
                    user's default
                    browser.

When no URLs are supplied, default
action is to read from standard input.
"""

const versionNumber: string = "0.2"

const commitHash: string = staticExec("git rev-parse HEAD")

const versionInfo: string = fmt"Unalix v{versionNumber} (+{commitHash})" &
    "\n" &
    fmt"Compiled on {hostOS} ({hostCPU}) using Nim v{NimVersion}"

const longNoVal: seq[string] = @[ ## Long options that doesn't require values
    "ignore-referral",
    "ignore-rules",
    "ignore-exceptions",
    "ignore-raw-rules",
    "ignore-redirections",
    "skip-blocked",
    "strip-duplicates",
    "strip-empty",
    "launch-in-browser",
    "help",
    "version"
]

const longVal: seq[string] = @[ ## Long options that require values
    "url"
]

var
    url: string
    parsedUrl: string
    argument: string
    ignoreReferralMarketing: bool
    ignoreRules: bool
    ignoreExceptions: bool
    ignoreRawRules: bool
    ignoreRedirections: bool
    skipBlocked: bool
    stripDuplicates: bool
    stripEmpty: bool
    launch_in_browser: bool

proc signalHandler() {.noconv.} =
    stdout.write("\n")
    quit(0)

setControlCHook(signalHandler)

var parser = initOptParser(longNoVal = longNoVal)

while true:
    parser.next()

    case parser.kind
    of cmdEnd:
        break
    of cmdShortOption, cmdLongOption:
        if not (parser.key in longVal & longNoVal):
            argument = if len(parser.key) > 1: fmt("--{parser.key}") else: fmt("-{parser.key}")
            stderr.write(fmt"unalix: unrecognized argument: {argument}" & "\n")
            quit(1)
        case parser.key
        of "version":
            stdout.write(versionInfo)
            quit(0)
        of "help":
            stdout.write(helpMessage)
            quit(0)
        of "url":
            url = parser.val
        of "ignore-referral":
            ignoreReferralMarketing = true
        of "ignore-rules":
            ignoreRules = true
        of "ignore-exceptions":
            ignoreExceptions = true
        of "ignore-raw-rules":
            ignoreRawRules = true
        of "ignore-redirections":
            ignoreRedirections = true
        of "skip-blocked":
            skipBlocked = true
        of "strip-duplicates":
            stripDuplicates = true
        of "strip-empty":
            stripEmpty = true
        of "launch-in-browser":
            launch_in_browser = true
    else:
        discard

if url == "":
    for stdinUrl in stdin.lines:
        parsedUrl = clearUrl(
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
        if launch_in_browser:
            stdout.write(fmt"Launching URL: {parsedUrl}" & "\n")
        else:
            stdout.write(parsedUrl & "\n")
else:
    parsedUrl = clearUrl(
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
    if launch_in_browser:
        stderr.write(fmt"Launching URL: {parsedUrl}" & "\n")
        openDefaultBrowser(parsedUrl)
    else:
        stdout.write(parsedUrl & "\n")
