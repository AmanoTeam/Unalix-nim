import parseopt
import strformat
import browsers

import ./core

const helpMessage: string = """
usage: unalix [-h] [-v] -u URL
              [--ignore-referral]
              [--ignore-rules]
              [--ignore-exceptions]
              [--ignore-raw-rules]
              [--ignore-redirections]
              [--skip-blocked]
              [--strip-duplicates]
              [--strip-empty] [-s] [-l]

Unalix is a small, dependency-free, fast
Nim package (and CLI tool) for removing
tracking fields from URLs.

optional arguments:
  -h, --help        show this help
                    message and exit
  -v, --version     show version number
                    and exit.
  -u URL, --url URL
                    HTTP URL you want to
                    unshort or remove
                    tracking fields from
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
  -s, --unshort     unshort the given
                    URL (HTTP requests
                    will be made).
  -l, --launch      launch URL with
                    user's default
                    browser.

When no URLs are supplied, default
action is to read from standard input.
"""

const versionNumber: string = "0.4"

const repository: string = staticExec("git config --get remote.origin.url")
const commitHash: string = staticExec("git rev-parse --short HEAD")

const versionInfo: string = fmt"Unalix v{versionNumber} ({repository}@{commitHash})" &
    "\n" &
    fmt"Compiled for {hostOS} ({hostCPU}) using Nim {NimVersion}" &
    fmt"({CompileDate}, {CompileTime})" &
    "\n"

const longNoVal: seq[string] = @[ ## Long options that doesn't require values
    "ignore-referral",
    "ignore-rules",
    "ignore-exceptions",
    "ignore-raw-rules",
    "ignore-redirections",
    "skip-blocked",
    "strip-duplicates",
    "strip-empty",
    "launch",
    "help",
    "version",
    "unshort"
]

const shortNoVal: set[char] = { ## Short options that doesn't require values
    'h',
    'v',
    'l'
}

var
    url: string
    newUrl: string
    argument: string
    ignoreReferralMarketing: bool
    ignoreRules: bool
    ignoreExceptions: bool
    ignoreRawRules: bool
    ignoreRedirections: bool
    skipBlocked: bool
    stripDuplicates: bool
    stripEmpty: bool
    launch: bool
    unshort: bool

proc signalHandler() {.noconv.} =
    stdout.write("\n")
    quit(0)

setControlCHook(signalHandler)

var parser = initOptParser(longNoVal = longNoVal, shortNoVal = shortNoVal)

while true:
    parser.next()

    case parser.kind
    of cmdEnd:
        break
    of cmdShortOption, cmdLongOption:
        case parser.key
        of "version":
            stdout.write(versionInfo)
            quit(0)
        of "v":
            stdout.write(versionInfo)
            quit(0)
        of "help":
            stdout.write(helpMessage)
            quit(0)
        of "h":
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
        of "launch":
            launch = true
        of "l":
            launch = true
        of "unshort":
            unshort = true
        of "s":
            unshort = true
        else:
            argument = if len(parser.key) > 1: fmt("--{parser.key}") else: fmt("-{parser.key}")
            stderr.write(fmt"unalix: unrecognized argument: {argument}" & "\n")
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
                stripDuplicates = stripDuplicates
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
            stdout.write(fmt"Launching: {newUrl}" & "\n")
        else:
            stdout.write(newUrl & "\n")
else:
    if unshort:
        newUrl = unshortUrl(
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
        stderr.write(fmt"Launching: {newUrl}" & "\n")
        openDefaultBrowser(newUrl)
    else:
        stdout.write(newUrl & "\n")
