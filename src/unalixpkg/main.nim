import std/parseopt
import std/strformat
import std/browsers
import std/strutils
import std/terminal
import std/os
import std/net
import std/asyncdispatch
import std/strscans

import ../unalix
import ./exceptions
import ./config

const
    helpMessage: string = staticRead(filename = "../../external/help_message.txt").strip()
    repository: string = staticExec(command = "git config --get remote.origin.url")
    commitHash: string = staticExec(command = "git rev-parse --short HEAD")
    versionInfo: string = &"Unalix v{UNALIX_VERSION} ({repository}@{commitHash})" &
        "\n" &
        &"Compiled for {hostOS} ({hostCPU}) using Nim {NimVersion} " &
        &"({CompileDate}, {CompileTime})"
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
        "strict-errors",
        "launch-with-browser",
        "timeout",
        "max-redirects",
        "disable-certificate-validation",
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

const caFileContent: string = staticRead(filename = "../../external/cacert.pem")

let
    caDir: string = getConfigDir() / "unalix" / "cacert"
    caFile: string = caDir / "cacert.pem"

if not caFile.fileExists():
    if not dirExists(dir = caDir):
        createDir(dir = caDir)
    
    writeFile(filename = caFile, content = caFileContent)
    setFilePermissions(filename = caFile, permissions = {fpUserRead})

var sslContext: SslContext = newContext(caFile = caFile)

setControlCHook(
    hook = proc(): void {.noconv.} =
        quit(0)
)

var
    urls: seq[string] = newSeq[string]()
    ignoreReferralMarketing: bool = false
    ignoreRules: bool = false
    ignoreExceptions: bool = false
    ignoreRawRules: bool = false
    ignoreRedirections: bool = false
    skipBlocked: bool = false
    stripDuplicates: bool = false
    stripEmpty: bool = false

var
    launchInBrowser: bool = false
    unshort: bool = false
    parseDocuments: bool = false
    strictErrors: bool = false
    timeout: int = DEFAULT_TIMEOUT
    maxRedirects: int = DEFAULT_MAX_REDIRECTS

proc getPrefixedArgument*(s: string): string =
    result = if len(s) > 1: "--" & s else: "-" & s

proc writeFatal*(msg: string, exitCode = -1): void =
    
    if stdout.isatty():
        stderr.styledWriteLine(fgRed, "fatal: ", fgWhite, msg)
    else:
        stderr.write(&"faltal: {msg}\n")
    
    if exitCode >= 0:
        quit(exitCode)

proc writeError*(msg: string, exitCode = -1): void =
    
    if stdout.isatty():
        stderr.styledWriteLine(fgRed, "error: ", fgWhite, msg)
    else:
        stderr.write(&"error: {msg}\n")
    
    if exitCode >= 0:
        quit(exitCode)

proc writeStdout*(msg: string, exitCode = -1): void =

    stdout.write(&"{msg}\n")
    
    if exitCode >= 0:
        quit(exitCode)

proc handleUrl(url: string): void =
    
    var newUrl: string
    
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
                stripDuplicates = stripDuplicates,
                parseDocuments = parseDocuments,
                timeout = timeout,
                maxRedirects = maxRedirects,
                sslContext = sslContext
            )
        except ConnectError as e:
            let exception: ref Exception = if e.parent.isNil(): e else: e.parent
            
            if strictErrors:
                writeFatal(msg = &"{exception.msg} [{exception.name}]", exitCode = 1)
            else:
                writeError(msg = &"{exception.msg} [{exception.name}]")
            
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
    
    writeStdout(msg = newUrl)
    
    if launchInBrowser:
        openDefaultBrowser(url = newUrl)

var parser: OptParser = initOptParser(longNoVal = longNoVal, shortNoVal = shortNoVal)

while true:
    parser.next()

    case parser.kind
    of cmdEnd:
        break
    of cmdShortOption, cmdLongOption:
        case parser.key
        of "version", "v":
            writeStdout(msg = versionInfo, exitCode = 0)
        of "help", "h":
            writeStdout(msg = helpMessage, exitCode = 0)
        of "u", "url":
            if parser.val.isEmptyOrWhitespace():
                writeFatal(
                    msg = &"missing required value for argument: {getPrefixedArgument(parser.key)}",
                    exitCode = 1
                )
            
            urls.add(parser.val)
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
            launchInBrowser = true
        of "unshort", "s":
            unshort = true
        of "parse-documents":
            parseDocuments = true
        of "strict-errors":
            strictErrors = true
        of "timeout":
            if not scanf(input = parser.val, pattern = "$i$.", results = timeout):
                writeFatal(
                    msg = &"invalid numeric literal: {parser.val}",
                    exitCode = 1
                )
            
            timeout = timeout * 1000
        of "max-redirects":
            if not scanf(input = parser.val, pattern = "$i$.", results = maxRedirects):
                writeFatal(
                    msg = &"invalid numeric literal: {parser.val}",
                    exitCode = 1
                )
        of "disable-certificate-validation":
            sslContext = newContext(verifyMode = CVerifyNone)
        else:
            writeFatal(
                msg = &"unrecognized argument: {getPrefixedArgument(parser.key)}",
                exitCode = 1
            )
    of cmdArgument:
        if parser.key.isEmptyOrWhitespace():
            writeFatal(
                msg = "got empty URL when reading from args",
                exitCode = 1
            )
            
        urls.add(parser.key)

let stdinIsAtty: bool = stdin.isatty()

for url in urls:
    handleUrl(url = url)

if not stdinIsAtty:
    for url in stdin.lines:
        handleUrl(url = url)

if stdinIsAtty and len(urls) == 0:
    writeStdout(msg = helpMessage, exitCode = 0)
