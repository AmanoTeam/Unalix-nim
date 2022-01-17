import std/sugar
import std/tables
import std/net
import std/strutils
import std/json
import std/uri
import std/re

import ./types
import ./rulesets
import ./utils

when defined(android):
    import os
    
    {.passC: "-I" & parentDir(currentSourcePath) / "android".}
    {.compile: "android/glob.c".}

proc compileRulesets(rulesetsList: JsonNode): seq[TableRef[string, RulesetNode]] =
    ## Compile rulesets from a JsonNode object

    result = newSeq[TableRef[string, RulesetNode]]()

    for provider in rulesetsList:
        var table: TableRef[string, RulesetNode] = newTable[string, RulesetNode]()

        # This field is ignored by Unalix, we are leaving it here just for reference
        # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
        table["providerName"] = RulesetNode(kind: nkString, strVal: provider["providerName"].getStr())

        # https://docs.clearurls.xyz/latest/specs/rules/#urlpattern
        table["urlPattern"] = RulesetNode(kind: nkRegex, regexVal: rex(provider["urlPattern"].getStr()))

        # https://docs.clearurls.xyz/latest/specs/rules/#completeprovider
        table["completeProvider"] = RulesetNode(kind: nkBool, boolVal: provider["completeProvider"].getBool())

        # https://docs.clearurls.xyz/latest/specs/rules/#rules
        table["rules"] = RulesetNode(
            kind: nkSeqRegex,
            seqRegexVal: block: collect newSeq: (for rule in provider["rules"]: rex("(%(?:26|23)|&|^)" & rule.getStr() & "(?:(?:=|%3[Dd])[^&]*)"))
        )

        # https://docs.clearurls.xyz/latest/specs/rules/#rawrules
        table["rawRules"] = RulesetNode(
            kind: nkSeqRegex,
            seqRegexVal: block: collect newSeq: (for rawRule in provider["rawRules"]: rex(rawRule.getStr()))
        )

        # https://docs.clearurls.xyz/latest/specs/rules/#referralmarketing
        table["referralMarketing"] = RulesetNode(
            kind: nkSeqRegex,
            seqRegexVal: block: collect newSeq: (for referral in provider["referralMarketing"]: rex("(%(?:26|23)|&|^)" & referral.getStr() & "(?:(?:=|%3[Dd])[^&]*)"))
        )

        # https://docs.clearurls.xyz/latest/specs/rules/#exceptions
        table["exceptions"] = RulesetNode(
            kind: nkSeqRegex,
            seqRegexVal: block: collect newSeq: (for exception in provider["exceptions"]: rex(exception.getStr()))
        )

        # https://docs.clearurls.xyz/latest/specs/rules/#redirections
        table["redirections"] = RulesetNode(
            kind: nkSeqRegex,
            seqRegexVal: block: collect newSeq: (for redirection in provider["redirections"]: rex(redirection.getStr() & ".*"))
        )

        # This field is ignored by Unalix, we are leaving it here just for reference
        # https://docs.clearurls.xyz/latest/specs/rules/#forceredirection
        table["forceRedirection"] = RulesetNode(kind: nkBool, boolVal: provider["forceRedirection"].getBool())

        result.add(table)

var rulesetsTable {.threadvar.}: seq[TableRef[string, RulesetNode]]
rulesetsTable = compileRulesets(rulesetsList = rulesetsNode)

proc clearUrl*(
    url: string,
    ignoreReferralMarketing: bool = false,
    ignoreRules: bool = false,
    ignoreExceptions: bool = false,
    ignoreRawRules: bool = false,
    ignoreRedirections: bool = false,
    skipBlocked: bool = false,
    stripDuplicates: bool = false,
    stripEmpty: bool = false
): string =

    var thisUrl: string = url
    var uri: Uri

    block mainLoop:
        for ruleset in rulesetsTable:
            if skipBlocked and ruleset["completeProvider"].boolVal:
                continue

            if thisUrl.match(pattern = ruleset["urlPattern"].regexVal):
                if not ignoreExceptions:
                    var exceptionMatched: bool
                    for exception in ruleset["exceptions"].seqRegexVal:
                        if thisUrl.match(pattern = exception):
                            exceptionMatched = true
                            break
                    if exceptionMatched:
                        continue

                if not ignoreRedirections:
                    for redirection in ruleset["redirections"].seqRegexVal:
                        let redirectionResult: string = thisUrl.replacef(sub = redirection, by = "$1")

                        # Skip empty URLs
                        if redirectionResult.isEmptyOrWhitespace():
                            continue

                        # Skip duplicate URLs
                        if redirectionResult == thisUrl:
                            continue

                        uri = parseUri(
                            uri = decodeUrl(s = redirectionResult, decodePlus = false)
                        )

                        # Workaround for URLs without scheme (see https://github.com/ClearURLs/Addon/issues/71)
                        if uri.scheme.isEmptyOrWhitespace():
                            uri.scheme = "http"

                        thisUrl = clearUrl(
                            url = requoteUri(uri = $uri),
                            ignoreReferralMarketing = ignoreReferralMarketing,
                            ignoreRules = ignoreRules,
                            ignoreExceptions = ignoreExceptions,
                            ignoreRawRules = ignoreRawRules,
                            ignoreRedirections = ignoreRedirections,
                            skipBlocked = skipBlocked,
                            stripDuplicates = stripDuplicates,
                            stripEmpty = stripEmpty
                        )

                        break mainLoop

                uri = thisUrl.parseUri()

                if not uri.query.isEmptyOrWhitespace():
                    if not ignoreRules:
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.query = uri.query.replacef(sub = rule, by = "$1")
                    if not ignoreReferralMarketing:
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.query = uri.query.replacef(sub = referral, by = "$1")

                # The anchor might contains tracking fields as well
                if not uri.anchor.isEmptyOrWhitespace():
                    if not ignoreRules:
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.anchor = uri.anchor.replacef(sub = rule, by = "$1")
                    if not ignoreReferralMarketing:
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.anchor = uri.anchor.replacef(sub = referral, by = "$1")

                if not uri.path.isEmptyOrWhitespace():
                    if not ignoreRawRules:
                        for rawRule in ruleset["rawRules"].seqRegexVal:
                            uri.path = uri.path.replacef(sub = rawRule, by = "$1")

                thisUrl = $uri

    uri = thisUrl.parseUri()

    if not uri.query.isEmptyOrWhitespace():
        uri.query = filterQuery(
            query = uri.query,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    if not uri.anchor.isEmptyOrWhitespace():
        uri.anchor = filterQuery(
            query = uri.anchor,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    result = $uri
