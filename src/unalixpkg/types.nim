import std/re
import std/httpcore

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
        httpVersion*: HttpVersion
        statusCode*: HttpCode
        headers*: HttpHeaders
        body*: string

func initResponse*(
    httpVersion: HttpVersion,
    statusCode: HttpCode,
    headers: HttpHeaders,
    body: string
): Response =
    result.httpVersion = httpVersion
    result.statusCode = statusCode
    result.headers = headers
    result.body = body    
