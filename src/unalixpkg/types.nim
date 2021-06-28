import re
import json

type
    NodeKind* = enum
        nkBool,
        nkString,
        nkRegex,
        nkSeqRegex
    Node* = ref object
        case kind*: NodeKind
        of nkBool:
            boolVal*: bool
        of nkString:
            strVal*: string
        of nkRegex:
            regexVal*: Regex
        of nkSeqRegex:
            seqRegexVal*: seq[Regex]
    Response* = object
        httpVersion: float
        statusCode: int
        statusMessage: string
        headers: seq[(string, string)]
        body: string

func initResponse*(
    httpVersion: float,
    statusCode: int,
    statusMessage: string,
    headers: seq[(string, string)],
    body: string
): Response =
    result.httpVersion = httpVersion
    result.statusCode = statusCode
    result.statusMessage = statusMessage
    result.headers = headers
    result.body = body    

proc getJson*(self: Response): JsonNode =
    result = parseJson(self.body)

proc hasHeader*(self: Response, name: string): bool =
    for (key, value) in self.headers:
        if key == name:
            return true
    result = false

proc getHeader*(self: Response, name: string): string =
    for (key, value) in self.headers:
        if key == name:
            return value
