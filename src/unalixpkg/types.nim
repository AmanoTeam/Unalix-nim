import re

# https://forum.nim-lang.org/t/4233#26344
type
  NodeKind = enum
    nkBool,
    nkString,
    nkRegex,
    nkSeqRegex
  
  Node = ref object
    case kind: NodeKind
    of nkBool: boolVal: bool
    of nkString: strVal: string
    of nkRegex: regexVal: Regex
    of nkSeqRegex: seqRegexVal: seq[Regex]
