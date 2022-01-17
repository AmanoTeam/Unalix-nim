import std/re
import std/httpcore
import std/net

type
    NodeKind* {.final, pure.} = enum
        nkBool,
        nkString,
        nkRegex,
        nkSeqRegex,
        nkSeqString
    RulesetNode* {.final, pure.} = ref object
        case kind*: NodeKind
        of nkBool:
            boolVal*: bool
        of nkString:
            strVal*: string
        of nkRegex:
            regexVal*: Regex
        of nkSeqRegex:
            seqRegexVal*: seq[Regex]
        of nkSeqString:
            seqStringVal*: seq[string]
    Response* {.final.} = object
        socket*: Socket
        httpVersion*: HttpVersion
        statusCode*: HttpCode
        statusMessage*: string
        headers*: HttpHeaders
        body*: string
    SyncUnalix* = object
    AsyncUnalix* = object

func initResponse*(
    httpVersion: HttpVersion,
    statusCode: HttpCode,
    statusMessage: string,
    headers: HttpHeaders,
    body: string
): Response =
    result.httpVersion = httpVersion
    result.statusCode = statusCode
    result.statusMessage = statusMessage
    result.headers = headers
    result.body = body    
