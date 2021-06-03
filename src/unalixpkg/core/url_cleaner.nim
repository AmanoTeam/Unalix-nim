import re
import uri
import tables
import json
import sugar
import tables

include ../types

include ../rulesets
import ../utils

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

let rulesetsTable = compileRulesets(rulesetsNode)

proc clearUrl(
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
    ##
    ##    This method implements the same specification used in the addon version of ClearURLs (with a few minor exceptions)
    ##    for removing tracking fields and unshortening URLs.
    ##
    ##    Parameters:
    ##
    ##        url (`string`):
    ##            A string representing an HTTP URL.
    ##
    ##        ignoreReferralMarketing (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not remove referral marketing fields from the URL query. Defaults to `false`.
    ##
    ##            This is similar to ClearURLs"s **"Allow referral marketing"** option.
    ##
    ##        ignoreRules (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not remove tracking fields from the given URL. Defaults to `false`.
    ##
    ##        ignoreExceptions (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore exceptions for the given URL. Defaults to `false`.
    ##
    ##        ignoreRawRules (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore raw rules for the given URL. Defaults to `false`.
    ##
    ##        ignoreRedirections (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to ignore redirection rules for the given URL. Defaults to `false`.
    ##
    ##        skipBlocked (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to not process rules for blocked URLs. Defaults to `false`.
    ##
    ##            This is similar to ClearURLs **"Allow domain blocking"** option, but instead of blocking access to the URL,
    ##            we just ignore all rulesets where it"s blocked.
    ##
    ##        stripDuplicates (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to strip fields with duplicate names. Defaults to `false`.
    ##
    ##        stripEmpty (`bool` | **optional**):
    ##            Pass `true` to instruct Unalix to strip fields with empty values. Defaults to `false`.
    ##
    ##    Usage examples:
    ##
    ##      Common rules (used to remove tracking fields found in the URL query)
    ##
    ##          .. code-block::
    ##            from unalix import clearUrl
    ##
    ##            var url = "https://deezer.com/track/891177062?utm_source=deezer"
    ##
    ##            doAssert clearUrl(url) == "https://deezer.com/track/891177062"
    ##
    ##      Redirection rules (used to extract redirect URLs found in any part of the URL)
    ##
    ##          .. code-block::
    ##            from unalix import clearUrl
    ##
    ##            var url = "https://www.google.com/url?q=https://pypi.org/project/Unalix"
    ##
    ##            doAssert clearUrl(url) == "https://pypi.org/project/Unalix"
    ##
    ##      Raw rules (used to remove tracking elements found in any part of the URL)
    ##
    ##          .. code-block::
    ##            from unalix import clearUrl
    ##
    ##            var url = "https://www.amazon.com/gp/B08CH7RHDP/ref=as_li_ss_tl"
    ##
    ##            doAssert clearUrl(url) == "https://www.amazon.com/gp/B08CH7RHDP"
    ##
    ##      Referral marketing rules (used to remove referral marketing fields found in the URL query)
    ##
    ##          .. code-block::
    ##            from unalix import clearUrl
    ##
    ##            var url = "https://natura.com.br/p/2458?consultoria=promotop"
    ##
    ##            doAssert clearUrl(url) == "https://natura.com.br/p/2458"
    ##

    var
        parsedUrl, redirectionResult: string
        uri: Uri
        exceptionMatched: bool

    parsedUrl = url

    block mainLoop:
        for ruleset in rulesetsTable:

            if skipBlocked and ruleset["completeProvider"].boolVal:
                continue

            if match(parsedUrl, ruleset["urlPattern"].regexVal):
                if not ignoreExceptions:
                    exceptionMatched = false
                    for exception in ruleset["exceptions"].seqRegexVal:
                        if match(parsedUrl, exception):
                            exceptionMatched = true
                            break
                    if exceptionMatched:
                        continue

                if not ignoreRedirections:
                    for redirection in ruleset["redirections"].seqRegexVal:
                        redirectionResult = replacef(parsedUrl, redirection, "$1")

                        # Skip empty URLs
                        if redirectionResult == "":
                            continue

                        if redirectionResult == parsedUrl:
                            continue

                        uri = parseUri(decodeUrl(redirectionResult, decodePlus = false))

                        # https://github.com/ClearURLs/Addon/issues/71
                        if uri.scheme == "":
                            uri.scheme = "http"

                        parsedUrl = clearUrl(
                            url = requoteUri($uri),
                            ignoreReferralMarketing = ignoreReferralMarketing,
                            ignoreRules = ignoreRules,
                            ignoreExceptions = ignoreExceptions,
                            ignoreRawRules = ignoreRawRules,
                            ignoreRedirections = ignoreRedirections,
                            skipBlocked = skipBlocked
                        )

                        break mainLoop

                uri = parseUri(parsedUrl)

                if uri.query != "":
                    if not ignoreRules:
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.query = replacef(uri.query, rule, "$1")
                    if not ignoreReferralMarketing:
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.query = replacef(uri.query, referral, "$1")

                if uri.anchor != "":
                    if not ignoreRules:
                        for rule in ruleset["rules"].seqRegexVal:
                            uri.anchor = replacef(uri.anchor, rule, "$1")
                    if not ignoreReferralMarketing:
                        for referral in ruleset["referralMarketing"].seqRegexVal:
                            uri.anchor = replacef(uri.anchor, referral, "$1")

                if uri.path != "":
                    if not ignoreRawRules:
                        for rawRule in ruleset["rawRules"].seqRegexVal:
                            uri.path = replacef(uri.path, rawRule, "$1")

                parsedUrl = $uri

    uri = parseUri(parsedUrl)

    if len(uri.query) != 0:
        uri.query = filterQuery(
            uri.query,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    if len(uri.anchor) != 0:
        uri.anchor = filterQuery(
            uri.anchor,
            stripDuplicates = stripDuplicates,
            stripEmpty = stripEmpty
        )

    result = $uri

export clearUrl
