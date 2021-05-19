import json
import sugar
import tables

include ../types

proc compileRulesets(rulesetsList: JsonNode): seq[TableRef[string, Node]] =

    var rulesets = newSeq[TableRef[string, Node]]()

    var
        table: TableRef[string, Node]
        jsonNode: JsonNode
        rules, referralMarketing, rawRules, exceptions, redirections: seq[Regex]

    for provider in rulesetsList:

        table = newTable[string, Node]()

        table["providerName"] = Node(kind: nkString, strVal: provider["providerName"].getStr())

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#urlpattern
        table["urlPattern"] = Node(kind: nkRegex, regexVal: rex(provider["urlPattern"].getStr()))

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#completeprovider
        table["completeProvider"] = Node(kind: nkBool, boolVal: provider["completeProvider"].getBool())

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#rules
        rules = block: collect newSeq: (for rule in provider["rules"]: rex(r"(%(?:26|23)|&|^)" & rule.getStr() & r"(?:(?:=|%3[Dd])[^&]*)"))
        table["rules"] = Node(kind: nkSeqRegex, seqRegexVal: rules)

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#rawrules
        rawRules = block: collect newSeq: (for rawRule in provider["rawRules"]: rex(rawRule.getStr()))
        table["rawRules"] = Node(kind: nkSeqRegex, seqRegexVal: rawRules)

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#referralmarketing
        referralMarketing = block: collect newSeq: (for referral in provider["referralMarketing"]: rex(r"(%(?:26|23)|&|^)" & referral.getStr() & r"(?:(?:=|%3[Dd])[^&]*)"))
        table["referralMarketing"] = Node(kind: nkSeqRegex, seqRegexVal: referralMarketing)

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#exceptions
        exceptions = block: collect newSeq: (for exception in provider["exceptions"]: rex(exception.getStr()))
        table["exceptions"] = Node(kind: nkSeqRegex, seqRegexVal: exceptions)

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#redirections
        redirections = block: collect newSeq: (for redirection in provider["redirections"]: rex(redirection.getStr() & r".*"))
        table["redirections"] = Node(kind: nkSeqRegex, seqRegexVal: redirections)

        # https://docs.clearurls.xyz/1.21.0/specs/rules/#forceredirection
        # This field is ignored by Unalix, we are leaving it here just for reference
        table["forceRedirection"] = Node(kind: nkBool, boolVal: provider["forceRedirection"].getBool())

        rulesets.add(table)

    result = rulesets
