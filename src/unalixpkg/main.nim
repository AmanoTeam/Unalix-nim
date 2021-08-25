import asyncdispatch
import parseopt
import strformat
import browsers

import ./core
import ./exceptions

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
                    from standard input]
  --ignore-referral
                    Instruct Unalix to
                    not remove referral
                    marketing fields
                    from the given URL.
                    [default: remove]
  --ignore-rules    Instruct Unalix to
                    not remove tracking
                    fields from the
                    given URL. [default:
                    don't ignore]
  --ignore-exceptions
                    Instruct Unalix to
                    ignore exceptions
                    for the given URL.
                    [default: don't
                    ignore]
  --ignore-raw-rules
                    Instruct Unalix to
                    ignore raw rules for
                    the given URL.
                    [default: don't
                    ignore]
  --ignore-redirections
                    Instruct Unalix to
                    ignore redirection
                    rules for the given
                    URL. [default: don't
                    ignore]
  --skip-blocked    Instruct Unalix to
                    ignore rule
                    processing for
                    blocked URLs.
                    [default: don't
                    ignore]
  --strip-duplicates
                    Instruct Unalix to
                    strip fields with
                    duplicate names.
                    [default: don't
                    strip]
  --strip-empty     Instruct Unalix to
                    strip fields with
                    empty values.
                    [default: don't
                    strip]
  -s, --unshort     Unshort the given
                    URL (HTTP requests
                    will be made).
                    [default: don't try
                    to unshort]
  -l, --launch      Launch URL with
                    user's default
                    browser. [default:
                    don't launch]
"""

const
    versionNumber: string = "0.5.1"
    repository: string = staticExec("git config --get remote.origin.url")
    commitHash: string = staticExec("git rev-parse --short HEAD")
    versionInfo: string = fmt"Unalix v{versionNumber} ({repository}@{commitHash})" &
        "\n" &
        fmt"Compiled for {hostOS} ({hostCPU}) using Nim {NimVersion}" &
        fmt"({CompileDate}, {CompileTime})" &
        "\n"
    longNoVal: seq[string] = @[
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
    launch, unshort: bool
    parser: OptParser

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
        of "launch", "l":
            launch = true
        of "unshort", "s":
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
            newUrl = waitFor aunshortUrl(
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
        try:
            newUrl = waitFor aunshortUrl(
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
        except ConnectError as e:
            stderr.write(fmt"unalix: exception: {e.msg}" & "\n")
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
        stderr.write(fmt"Launching: {newUrl}" & "\n")
        openDefaultBrowser(newUrl)
    else:
        stdout.write(newUrl & "\n")
