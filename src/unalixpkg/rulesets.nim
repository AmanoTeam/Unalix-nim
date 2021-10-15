import json

let rulesetsNode*: JsonNode = %* [
    {
        "providerName": "amazon",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "p[fd]_rd_[a-z]*",
            "qid",
            "srs?",
            "__mk_[a-z]{1,3}_[a-z]{1,3}",
            "spIA",
            "ms3_c",
            "[a-z%0-9]*ie",
            "refRID",
            "colii?d",
            "[^a-z%0-9]adId",
            "qualifier",
            "_encoding",
            "smid",
            "field-lbr_brands_browse-bin",
            "ref_?",
            "th",
            "sprefix",
            "crid",
            "keywords",
            "cv_ct_[a-z]+",
            "linkCode",
            "creativeASIN",
            "ascsubtag",
            "aaxitk",
            "hsa_cr_id",
            "sb-ci-[a-z]+",
            "rnid",
            "dchild",
            "camp",
            "creative",
            "s"
        ],
        "rawRules": [
            "\\/ref=[^/?]*"
        ],
        "referralMarketing": [
            "tag",
            "ascsubtag"
        ],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,}){1,}\\/gp\\/.*?(?:redirector.html|cart\\/ajax-update.html|video\\/api\\/)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,}){1,}\\/(?:hz\\/reviews-render\\/ajax\\/|message-us\\?|s\\?)"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "amazon search",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,}){1,}\\/s\\?",
        "completeProvider": false,
        "rules": [
            "p[fd]_rd_[a-z]*",
            "qid",
            "srs?",
            "__mk_[a-z]{1,3}_[a-z]{1,3}",
            "spIA",
            "ms3_c",
            "[a-z%0-9]*ie",
            "refRID",
            "colii?d",
            "[^a-z%0-9]adId",
            "qualifier",
            "_encoding",
            "smid",
            "field-lbr_brands_browse-bin",
            "ref_?",
            "th",
            "sprefix",
            "crid",
            "cv_ct_[a-z]+",
            "linkCode",
            "creativeASIN",
            "ascsubtag",
            "aaxitk",
            "hsa_cr_id",
            "sb-ci-[a-z]+",
            "rnid",
            "dchild",
            "camp",
            "creative"
        ],
        "rawRules": [
            "\\/ref=[^/?]*"
        ],
        "referralMarketing": [
            "tag"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "fls-na.amazon",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?fls-na\\.amazon(?:\\.[a-z]{2,}){1,}",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "google",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "ved",
            "bi[a-z]*",
            "gfe_[a-z]*",
            "ei",
            "source",
            "gs_[a-z]*",
            "site",
            "oq",
            "esrc",
            "uact",
            "cd",
            "cad",
            "gws_[a-z]*",
            "atyp",
            "vet",
            "zx",
            "_u",
            "je",
            "dcr",
            "ie",
            "sei",
            "sa",
            "dpr",
            "btn[a-z]*",
            "usg",
            "cd",
            "cad",
            "uact",
            "aqs",
            "sourceid",
            "sxsrf",
            "rlz",
            "i-would-rather-use-firefox",
            "pcampaignid"
        ],
        "rawRules": [],
        "referralMarketing": [
            "referrer"
        ],
        "exceptions": [
            "^https?:\\/\\/mail\\.google\\.com\\/mail\\/u\\/",
            "^https?:\\/\\/(?:docs|accounts)\\.google(?:\\.[a-z]{2,}){1,}",
            "^https?:\\/\\/drive\\.google\\.com\\/videoplayback",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}(?:\\/upload)?\\/drive\\/",
            "^https?:\\/\\/news\\.google\\.com.*\\?hl=.",
            "^https?:\\/\\/hangouts\\.google\\.com\\/webchat.*?zx=.",
            "^https?:\\/\\/client-channel\\.google\\.com\\/client-channel.*?zx=.",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/s\\?tbm=map.*?gs_[a-z]*=.",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/(?:complete\\/search|setprefs|searchbyimage)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/(?:appsactivity|aclk\\?)"
        ],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/url\\?.*?(?:url|q)=(https?[^&]+)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/.*?adurl=([^&]+)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/amp\\/s\\/([^&]+)"
        ],
        "forceRedirection": true
    },
    {
        "providerName": "googleSearch",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/search\\?",
        "completeProvider": false,
        "rules": [
            "client",
            "sclient"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "googlesyndication",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?googlesyndication\\.com",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "doubleclick",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?doubleclick(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?doubleclick(?:\\.[a-z]{2,}){1,}\\/.*?tag_for_child_directed_treatment=;%3F([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "googleadservices",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?googleadservices\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?googleadservices\\.com\\/.*?adurl=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "globalRules",
        "urlPattern": ".*",
        "completeProvider": false,
        "rules": [
            "(?:%3F)?utm(?:_[a-z_]*)?",
            "(?:%3F)?ga_[a-z_]+",
            "(?:%3F)?yclid",
            "(?:%3F)?_openstat",
            "(?:%3F)?fb_action_(?:types|ids)",
            "(?:%3F)?fb_(?:source|ref)",
            "(?:%3F)?fbclid",
            "(?:%3F)?action_(?:object|type|ref)_map",
            "(?:%3F)?gs_l",
            "(?:%3F)?mkt_tok",
            "(?:%3F)?hmb_(?:campaign|medium|source)",
            "(?:%3F)?ref_?",
            "(?:%3F)?referrer",
            "(?:%3F)?gclid",
            "(?:%3F)?otm_[a-z_]*",
            "(?:%3F)?cmpid",
            "(?:%3F)?os_ehash",
            "(?:%3F)?_ga",
            "(?:%3F)?__twitter_impression",
            "(?:%3F)?wt_?z?mc",
            "(?:%3F)?wtrid",
            "(?:%3F)?[a-z]?mc",
            "(?:%3F)?dclid",
            "Echobox",
            "(?:%3F)?spm",
            "(?:%3F)?vn(?:_[a-z]*)+",
            "(?:%3F)?tracking_source",
            "(?:%3F)?ceneo_spo"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?matrix\\.org\\/_matrix\\/",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?(?:cloudflare\\.com|prismic\\.io|tangerine\\.ca|gitlab\\.com)",
            "^https?:\\/\\/myaccount.google(?:\\.[a-z]{2,}){1,}",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?gcsip\\.(?:com|nl)[^?]*\\?.*?&?ref_?=.",
            "^https?:\\/\\/[^/]+/[^/]+/[^/]+\\/-\\/refs\\/switch[^?]*\\?.*?&?ref_?=.",
            "^https?:\\/\\/bugtracker\\.[^/]*\\/[^?]+\\?.*?&?ref_?=[^/?&]*",
            "^https?:\\/\\/comment-cdn\\.9gag\\.com\\/.*?comment-list.json\\?",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?battle\\.net\\/login",
            "^https?:\\/\\/blizzard\\.com\\/oauth2",
            "^https?:\\/\\/kreditkarten-banking\\.lbb\\.de",
            "^https?:\\/\\/www\\.tinkoff\\.ru",
            "^https?:\\/\\/www\\.cyberport\\.de\\/adscript\\.php",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tweakers\\.net\\/ext\\/lt\\.dsp\\?.*?(?:%3F)?&?ref_?=.",
            "^https?:\\/\\/git(lab)?\\.[^/]*\\/[^?]+\\?.*?&?ref_?=[^/?&]*",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,}){1,}\\/message-us\\?",
            "^https?:\\/\\/authorization\\.td\\.com",
            "^https?:\\/\\/support\\.steampowered\\.com",
            "^https?:\\/\\/privacy\\.vakmedianet\\.nl\\/.*?ref=",
            "^https?:\\/\\/sso\\.serverplan\\.com\\/manage2fa\\/check\\?ref=",
            "^https?:\\/\\/login\\.meijer\\.com\\/.*?\\?ref=",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/(?:login_alerts|ajax|should_add_browser)/",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/groups\\/member_bio\\/bio_dialog\\/",
            "^https?:\\/\\/api\\.taiga\\.io",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?gog\\.com\\/click\\.html",
            "^https?:\\/\\/login\\.progressive\\.com",
            "^https?:\\/\\/www\\.sephora\\.com\\/api\\/",
            "^https?:\\/\\/www\\.contestgirl\\.com",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?agenciatributaria\\.gob\\.es",
            "^https?:\\/\\/login\\.ingbank\\.pl",
            "^wss?:\\/\\/(?:[a-z0-9-]+\\.)*?zoom\\.us",
            "^https?:\\/\\/api\\.bilibili\\.com",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?onet\\.pl\\/[^?]*\\?.*?utm_campaign=.",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?stripe\\.com\\/[^?]+.*?&?referrer=[^/?&]*",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?lichess\\.org\\/login.*?&?referrer=.*?"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "adtech",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?adtech(?:\\.[a-z]{2,}){1,}",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "contentpass",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?contentpass\\.(?:net|de)",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bf-ad",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bf-ad(?:\\.[a-z]{2,}){1,}",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "amazon-adsystem",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon-adsystem(?:\\.[a-z]{2,}){1,}",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon-adsystem(?:\\.[a-z]{2,}){1,}\\/v3\\/oor\\?"
        ],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon-adsystem(?:\\.[a-z]{2,}){1,}\\/x\\/c\\/.+?\\/([^&]+)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "adsensecustomsearchads",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?adsensecustomsearchads(?:\\.[a-z]{2,}){1,}",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "youtube",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?youtube\\.com",
        "completeProvider": false,
        "rules": [
            "feature",
            "gclid",
            "kw"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?youtube\\.com\\/signin\\?.*?"
        ],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?youtube\\.com\\/redirect?.*?q=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "youtube_pagead",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?youtube\\.com\\/pagead",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "youtube_apiads",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?youtube\\.com\\/api\\/stats\\/ads",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "facebook",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com",
        "completeProvider": false,
        "rules": [
            "hc_[a-z_%\\[\\]0-9]*",
            "[a-z]*ref[a-z]*",
            "__tn__",
            "eid",
            "__xts__(?:\\[|%5B)\\d(?:\\]|%5D)",
            "comment_tracking",
            "dti",
            "app",
            "video_source",
            "ftentidentifier",
            "pageid",
            "padding",
            "ls_ref",
            "action_history"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/.*?(plugins|ajax)\\/",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/dialog\\/(?:share|send)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/groups\\/member_bio\\/bio_dialog\\/",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/photo\\.php\\?",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/privacy\\/specific_audience_selector_dialog\\/",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com\\/photo\\/download\\/"
        ],
        "redirections": [
            "^https?:\\/\\/l[a-z]?\\.facebook\\.com/l\\.php\\?.*?u=(https?%3A%2F%2F[^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "twitter",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?twitter.com",
        "completeProvider": false,
        "rules": [
            "(?:ref_?)?src",
            "s",
            "cn",
            "ref_url"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "reddit",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?reddit.com",
        "completeProvider": false,
        "rules": [
            "%24deep_link",
            "\\$deep_link",
            "correlation_id",
            "ref_campaign",
            "ref_source",
            "%243p",
            "\\$3p",
            "%24original_url",
            "\\$original_url",
            "_branch_match_id"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/out\\.reddit\\.com\\/.*?url=([^&]*)",
            "^https?:\\/\\/click\\.redditmail\\.com\\/.*?url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "netflix",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?netflix.com",
        "completeProvider": false,
        "rules": [
            "trackId",
            "tctx",
            "jb[a-z]*?"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "techcrunch",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?techcrunch\\.com",
        "completeProvider": false,
        "rules": [
            "ncid",
            "sr",
            "sr_share"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bing",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bing(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "cvid",
            "form",
            "sk",
            "sp",
            "sc",
            "qs",
            "qp"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bing(?:\\.[a-z]{2,}){1,}\\/WS\\/redirect\\/"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "tweakers",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tweakers\\.net",
        "completeProvider": false,
        "rules": [
            "nb",
            "u"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "twitch",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?twitch\\.com",
        "completeProvider": false,
        "rules": [
            "tt_medium",
            "tt_content"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "vivaldi",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?vivaldi\\.com",
        "completeProvider": false,
        "rules": [
            "pk_campaign",
            "pk_kwd"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "indeed",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?indeed\\.com",
        "completeProvider": false,
        "rules": [
            "from",
            "alid",
            "[a-z]*tk"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?indeed\\.com\\/rc\\/clk"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "hhdotru",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?hh\\.ru",
        "completeProvider": false,
        "rules": [
            "vss",
            "t",
            "swnt",
            "grpos",
            "ptl",
            "stl",
            "exp",
            "plim"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "ebay",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?ebay(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "_trkparms",
            "_trksid",
            "_from",
            "hash"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?rover\\.ebay(?:\\.[a-z]{2,}){1,}\\/rover.*mpre=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "cnet",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?cnet\\.com",
        "completeProvider": false,
        "rules": [
            "ftag"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "imdb.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?imdb\\.com",
        "completeProvider": false,
        "rules": [
            "ref_",
            "pf_rd_[a-z]*"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "govdelivery.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?govdelivery\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?links\\.govdelivery\\.com.*\\/track\\?.*(https?:\\/\\/.*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "walmart.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?walmart\\.com",
        "completeProvider": false,
        "rules": [
            "u1",
            "ath[a-z]*"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "net-parade.it",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?net\\-parade\\.it",
        "completeProvider": false,
        "rules": [
            "pl"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "prvnizpravy.cz",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?prvnizpravy\\.cz",
        "completeProvider": false,
        "rules": [
            "xid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "youku.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?youku\\.com",
        "completeProvider": false,
        "rules": [
            "tpa"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "nytimes.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?nytimes\\.com",
        "completeProvider": false,
        "rules": [
            "smid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "tchibo.de",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tchibo\\.de",
        "completeProvider": false,
        "rules": [
            "wbdcd"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "steampowered",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?steampowered\\.com",
        "completeProvider": false,
        "rules": [
            "snr"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "steamcommunity",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?steamcommunity\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?steamcommunity\\.com\\/linkfilter\\/\\?url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "mozaws.net",
        "urlPattern": "https?:\\/\\/outgoing\\.prod\\.mozaws\\.net\\/",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "https?:\\/\\/[^/]+\\/v1\\/[0-9a-f]{64}\\/(.*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "shutterstock.com",
        "urlPattern": "https?:\\/\\/([a-z0-9-.]*\\.)shutterstock\\.com",
        "completeProvider": false,
        "rules": [
            "src"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "mozilla.org",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mozilla\\.org",
        "completeProvider": false,
        "rules": [
            "src",
            "platform",
            "redirect_source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mozilla.org\\/api"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "readdc.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?readdc\\.com",
        "completeProvider": false,
        "rules": [
            "ref"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "dailycodingproblem.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?dailycodingproblem\\.com",
        "completeProvider": false,
        "rules": [
            "email"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "github.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?github\\.com",
        "completeProvider": false,
        "rules": [
            "email_token",
            "email_source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "deviantart.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?deviantart\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?deviantart\\.com\\/.*?\\/outgoing\\?(.*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "site2.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?site2\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?site2\\.com.*?\\?.*=(.*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "site.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?site\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?site\\.com.*?\\?to=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "site3.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?site3\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?site3\\.com.*?\\?r=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "aliexpress",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?aliexpress(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "ws_ab_test",
            "btsid",
            "algo_expid",
            "algo_pvid",
            "gps-id",
            "scm[_a-z-]*",
            "cv",
            "af",
            "mall_affr",
            "sk",
            "dp",
            "terminal_id",
            "aff_request_id"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "mozillazine.org",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mozillazine\\.org",
        "completeProvider": false,
        "rules": [
            "sid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "9gag.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?9gag\\.com",
        "completeProvider": false,
        "rules": [
            "ref"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/comment-cdn\\.9gag\\.com\\/.*?comment-list.json\\?"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "linksynergy.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?linksynergy\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?linksynergy\\.com\\/.*?murl=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "giphy.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?giphy\\.com",
        "completeProvider": false,
        "rules": [
            "ref"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "gate.sc",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?gate\\.sc",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?gate\\.sc\\/.*?url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "vk.com",
        "urlPattern": "^https?:\\/\\/vk\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/vk\\.com\\/away\\.php\\?to=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "woot.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?woot\\.com",
        "completeProvider": false,
        "rules": [
            "ref_?"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "vitamix.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?vitamix\\.com",
        "completeProvider": false,
        "rules": [
            "_requestid",
            "cid",
            "dl",
            "di",
            "sd",
            "bi"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "curseforge.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?curseforge\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?curseforge\\.com\\/linkout\\?remoteUrl=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "messenger.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?messenger\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/l\\.messenger\\.com\\/l\\.php\\?u=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "nypost.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?nypost\\.com",
        "completeProvider": false,
        "rules": [
            "__twitter_impression"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "ozon.ru",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?ozon\\.ru",
        "completeProvider": false,
        "rules": [
            "partner"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "norml.org",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?norml\\.org",
        "completeProvider": false,
        "rules": [
            "link_id",
            "can_id",
            "source",
            "email_referrer",
            "email_subject"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "LinkedIn",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?linkedin\\.com",
        "completeProvider": false,
        "rules": [
            "refId",
            "trk",
            "li[a-z]{2}"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "LinkedIn Learning",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?linkedin\\.com\\/learning",
        "completeProvider": false,
        "rules": [
            "u"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "smartredirect.de",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?smartredirect\\.de",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?smartredirect\\.de.*?url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "SPIEGEL ONLINE",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?spiegel\\.de",
        "completeProvider": false,
        "rules": [
            "b"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "rutracker.org",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?rutracker\\.org",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            ".*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "instagram",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?instagram\\.com",
        "completeProvider": false,
        "rules": [
            "igshid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            ".*u=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "lazada.com.my",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?lazada\\.com\\.my",
        "completeProvider": false,
        "rules": [
            "ad_src",
            "did",
            "pa",
            "mp",
            "impsrc",
            "cid",
            "pos"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "imgsrc.ru",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?imgsrc\\.ru",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?dlp\\.imgsrc\\.ru\\/go\\/\\d+\\/\\d+\\/\\d+\\/([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "boredpanda.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?boredpanda\\.com",
        "completeProvider": false,
        "rules": [
            "h"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "awstrack.me",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?awstrack\\.me",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?awstrack\\.me\\/.*\\/(https?.*?)\\/"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "exactag.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?exactag\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?exactag\\.com.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "bahn.de",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bahn\\.de",
        "completeProvider": false,
        "rules": [
            "dbkanal_[0-9]{3}"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "disq.us",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?disq\\.us",
        "completeProvider": false,
        "rules": [
            "cuid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?disq\\.us\\/.*?url=([^&]*)%3A"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "anonym.to",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?anonym\\.to",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?anonym\\.to.*\\?([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "moosejaw.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?moosejaw\\.com",
        "completeProvider": false,
        "rules": [
            "cm_lm",
            "cm_mmc",
            "webUserId",
            "spMailingID",
            "spUserID",
            "spJobID",
            "spReportId"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "spotify.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?spotify\\.com",
        "completeProvider": false,
        "rules": [
            "si"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "yandex",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?(?:yandex(?:\\.[a-z]{2,}){1,}|ya\\.ru)",
        "completeProvider": false,
        "rules": [
            "lr",
            "redircnt"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "healio.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?healio\\.com",
        "completeProvider": false,
        "rules": [
            "ecp",
            "m_bt"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "zoho.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?zoho\\.com",
        "completeProvider": false,
        "rules": [
            "iref"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "snapchat.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?snapchat\\.com",
        "completeProvider": false,
        "rules": [
            "sc_referrer",
            "sc_ua"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "medium.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?medium\\.com",
        "completeProvider": false,
        "rules": [
            "source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "swp.de",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?swp\\.de",
        "completeProvider": false,
        "rules": [
            "source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "wps.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?wps\\.com",
        "completeProvider": false,
        "rules": [
            "from"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "accounts.firefox.com",
        "urlPattern": "^https?:\\/\\/(?:accounts\\.)?firefox\\.com",
        "completeProvider": false,
        "rules": [
            "context",
            "entrypoint",
            "form_type"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "support.mozilla.org",
        "urlPattern": "^https?:\\/\\/(?:support\\.)?mozilla\\.org",
        "completeProvider": false,
        "rules": [
            "as"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "diepresse.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?diepresse\\.com",
        "completeProvider": false,
        "rules": [
            "from",
            "xtor",
            "xt_at"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "newsletter.lidl.com",
        "urlPattern": "^https?:\\/\\/newsletter\\.lidl(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "x"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "allegro.pl",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?allegro\\.pl",
        "completeProvider": false,
        "rules": [
            "reco_id",
            "sid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "backcountry.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?backcountry\\.com",
        "completeProvider": false,
        "rules": [
            "CMP_SKU",
            "MER",
            "mr:trackingCode",
            "mr:device",
            "mr:adType",
            "iv_",
            "CMP_ID",
            "k_clickid",
            "rmatt",
            "INT_ID",
            "ti",
            "fl"
        ],
        "rawRules": [],
        "referralMarketing": [
            "mr:referralID"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "meetup.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?meetup\\.com",
        "completeProvider": false,
        "rules": [
            "rv",
            "_xtd"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "apple.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?apple\\.com",
        "completeProvider": false,
        "rules": [
            "app",
            "ign-itsc[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "alabout.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?alabout\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?alabout\\.com.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "newyorker.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?newyorker\\.com",
        "completeProvider": false,
        "rules": [
            "source",
            "bxid",
            "cndid",
            "esrc",
            "mbid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "gog.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?gog\\.com",
        "completeProvider": false,
        "rules": [
            "track_click",
            "link_id"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "tradedoubler.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tradedoubler\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tradedoubler\\.com.*(?:url|_td_deeplink)=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "theguardian.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?theguardian\\.com",
        "completeProvider": false,
        "rules": [
            "CMP"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "srvtrck.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?srvtrck\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?srvtrck\\.com.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "mysku.ru",
        "urlPattern": "^https?:\\/\\/mysku\\.ru",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/mysku\\.ru.*r=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "admitad.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?admitad\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?admitad\\.com.*ulp=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "taobao.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?taobao\\.com",
        "completeProvider": false,
        "rules": [
            "price",
            "sourceType",
            "suid",
            "ut_sk",
            "un",
            "share_crt_v",
            "sp_tk",
            "cpp",
            "shareurl",
            "short_name",
            "app",
            "scm[_a-z-]*",
            "pvid",
            "algo_expid",
            "algo_pvid",
            "ns",
            "abbucket",
            "ali_refid",
            "ali_trackid",
            "acm",
            "utparam",
            "pos",
            "abtest",
            "trackInfo",
            "utkn",
            "scene",
            "mytmenu",
            "turing_bucket",
            "lygClk",
            "impid",
            "bftTag",
            "bftRwd",
            "spm"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "tmall.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tmall\\.com",
        "completeProvider": false,
        "rules": [
            "price",
            "sourceType",
            "suid",
            "ut_sk",
            "un",
            "share_crt_v",
            "sp_tk",
            "cpp",
            "shareurl",
            "short_name",
            "app",
            "scm[_a-z-]*",
            "pvid",
            "algo_expid",
            "algo_pvid",
            "ns",
            "abbucket",
            "ali_refid",
            "ali_trackid",
            "acm",
            "utparam",
            "pos",
            "abtest",
            "trackInfo",
            "user_number_id",
            "utkn",
            "scene",
            "mytmenu",
            "turing_bucket",
            "lygClk",
            "impid",
            "bftTag",
            "bftRwd",
            "activity_id"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "tb.cn",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tb\\.cn",
        "completeProvider": false,
        "rules": [
            "sm"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bilibili.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bilibili\\.com",
        "completeProvider": false,
        "rules": [
            "callback",
            "spm_id_from",
            "from_source",
            "from",
            "seid",
            "share_source",
            "msource",
            "refer_from",
            "share_medium",
            "share_source",
            "share_plat",
            "share_tag",
            "share_session_id",
            "timestamp",
            "unique_k"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/api\\.bilibili\\.com"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "m.bilibili.com",
        "urlPattern": "^https?:\\/\\/m\\.bilibili\\.com",
        "completeProvider": false,
        "rules": [
            "bbid",
            "ts"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "live.bilibili.com",
        "urlPattern": "^https?:\\/\\/live\\.bilibili\\.com",
        "completeProvider": false,
        "rules": [
            "visit_id",
            "session_id",
            "broadcast_type",
            "is_room_feed"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "marketscreener.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?marketscreener\\.com",
        "completeProvider": false,
        "rules": [
            "type_recherche",
            "mots",
            "noredirect",
            "RewriteLast",
            "lien",
            "aComposeInputSearch",
            "type_recherche_forum",
            "add_mots",
            "countview"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?marketscreener\\.com\\/search\\/\\?"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "marketscreener.com search",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?marketscreener\\.com\\/search\\/\\?",
        "completeProvider": false,
        "rules": [
            "type_recherche",
            "noredirect",
            "RewriteLast",
            "lien",
            "aComposeInputSearch",
            "type_recherche_forum",
            "countview"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bestbuy.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bestbuy\\.com",
        "completeProvider": false,
        "rules": [
            "irclickid",
            "irgwc",
            "loc",
            "acampID",
            "mpid",
            "intl"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "digidip.net",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?digidip\\.net",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?digidip\\.net.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "tiktok.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tiktok\\.com",
        "completeProvider": false,
        "rules": [
            "u_code",
            "preview_pb",
            "_d",
            "timestamp",
            "user_id",
            "share_app_name",
            "share_iid",
            "source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "autoplus.fr",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?autoplus\\.fr",
        "completeProvider": false,
        "rules": [
            "idprob",
            "hash",
            "sending_id",
            "site_id",
            "dr_tracker"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bigfishgames.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bigfishgames\\.com",
        "completeProvider": false,
        "rules": [
            "pc",
            "npc",
            "npv[0-9]+",
            "npi"
        ],
        "rawRules": [
            "\\?pc$"
        ],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "dpbolvw.net",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?dpbolvw\\.net",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?dpbolvw\\.net.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "humblebundle.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?humblebundle\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [
            "partner"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "cafepedagogique.net",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?cafepedagogique\\.net",
        "completeProvider": false,
        "rules": [
            "actId",
            "actCampaignType",
            "actSource"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bloculus.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bloculus\\.com",
        "completeProvider": false,
        "rules": [
            "tl_[a-z_]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "mailpanion.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mailpanion\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mailpanion\\.com.*destination=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "signtr.website",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?signtr\\.website",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?signtr\\.website.*redirect=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "mailtrack.io",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mailtrack\\.io",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mailtrack\\.io.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "zillow.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?zillow\\.com",
        "completeProvider": false,
        "rules": [
            "rtoken"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "realtor.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?realtor\\.com",
        "completeProvider": false,
        "rules": [
            "ex",
            "identityID",
            "MID",
            "RID"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "redfin.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?redfin\\.com",
        "completeProvider": false,
        "rules": [
            "riftinfo"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "epicgames.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?epicgames\\.com",
        "completeProvider": false,
        "rules": [
            "epic_affiliate",
            "epic_gameId"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "onet.pl",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?onet\\.pl",
        "completeProvider": false,
        "rules": [
            "srcc",
            "utm_v",
            "utm_medium",
            "utm_source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "allrecipes.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?allrecipes\\.com",
        "completeProvider": false,
        "rules": [
            "internalSource",
            "referringId",
            "referringContentType",
            "clickId"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "europe1.fr",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?europe1\\.fr",
        "completeProvider": false,
        "rules": [
            "xtor"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "effiliation.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?effiliation\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?effiliation\\.com.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "argos.co.uk",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?argos\\.co\\.uk",
        "completeProvider": false,
        "rules": [
            "istCompanyId",
            "istFeedId",
            "istItemId",
            "istBid",
            "clickOrigin"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "hlserve.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?hlserve\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?hlserve\\.com.*dest=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "thunderbird.net",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?thunderbird\\.net",
        "completeProvider": false,
        "rules": [
            "src"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "cnbc.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?cnbc\\.com",
        "completeProvider": false,
        "rules": [
            "__source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "roblox.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?roblox\\.com",
        "completeProvider": false,
        "rules": [
            "refPageId"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "cell.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?cell\\.com",
        "completeProvider": false,
        "rules": [
            "_returnURL"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "academic.oup.com",
        "urlPattern": "^https?:\\/\\/academic\\.oup\\.com",
        "completeProvider": false,
        "rules": [
            "redirectedFrom"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "flexlinkspro.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?flexlinkspro\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?flexlinkspro\\.com.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "agata88.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?agata88\\.com",
        "completeProvider": false,
        "rules": [
            "source"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "hs.fi",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?hs\\.fi",
        "completeProvider": false,
        "rules": [
            "share"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "yle.fi",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?yle\\.fi",
        "completeProvider": false,
        "rules": [
            "origin"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "ccbill.com",
        "urlPattern": "^https?:\\/\\/refer\\.ccbill\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/refer\\.ccbill\\.com.*HTML=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "flipkart",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?flipkart\\.com",
        "completeProvider": false,
        "rules": [
            "otracker.?",
            "ssid",
            "[cilp]id",
            "marketplace",
            "store",
            "srno",
            "store",
            "ppn",
            "ppt",
            "fm",
            "collection-tab-name",
            "sattr\\[\\]",
            "p\\[\\]",
            "st"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "idealo.de",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?idealo\\.de",
        "completeProvider": false,
        "rules": [
            "sid",
            "src",
            "siteId",
            "lcb",
            "leadOutUrl",
            "offerListId",
            "osId",
            "cancelUrl",
            "disc"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "idealo-partner.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?idealo-partner\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?idealo-partner\\.com.*trg=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "teletrader.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?teletrader\\.com",
        "completeProvider": false,
        "rules": [
            "internal"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "webgains.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?webgains\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?webgains\\.com.*wgtarget=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "deeplearning.ai",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?deeplearning\\.ai",
        "completeProvider": false,
        "rules": [
            "ecid",
            "_hsmi",
            "_hsenc"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "getpocket.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?getpocket\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?getpocket\\.com.*url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "gamespot.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?gamespot\\.com",
        "completeProvider": false,
        "rules": [
            "PostType",
            "ServiceType",
            "ftag",
            "UniqueID",
            "TheTime"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "tokopedia.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tokopedia\\.com",
        "completeProvider": false,
        "rules": [
            "src",
            "trkid",
            "whid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?tokopedia\\.com\\/promo.*r=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "wkorea.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?wkorea\\.com",
        "completeProvider": false,
        "rules": [
            "ddw",
            "ds_ch"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "eonline.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?eonline\\.com",
        "completeProvider": false,
        "rules": [
            "source",
            "medium",
            "content"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "reuters.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?reuters\\.com",
        "completeProvider": false,
        "rules": [
            "taid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "app.adjust.com",
        "urlPattern": "^https?:\\/\\/app\\.adjust\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/app\\.adjust\\.com.*redirect=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "change.org",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?change\\.org",
        "completeProvider": false,
        "rules": [
            "source_location",
            "psf_variant",
            "share_intent"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "ceneo.pl",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?ceneo\\.pl",
        "completeProvider": false,
        "rules": [
            "tag"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "wired.com",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?wired\\.com",
        "completeProvider": false,
        "rules": [
            "intcid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "amazon",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,})",
        "completeProvider": false,
        "rules": [
            "hv[a-z]{3,6}",
            "vtargid",
            "h",
            "hydadcr",
            "psc",
            "linkId",
            "language",
            "condition",
            "marketplaceID",
            "s",
            "url",
            "Source",
            "sc_[a-z]+",
            "primeCampaignId",
            "sub",
            "__mk_.+",
            "lmdsid",
            "refinements",
            "rps"
        ],
        "rawRules": [
            "\\b\\/.+(?=\\/dp)"
        ],
        "referralMarketing": [
            "tag"
        ],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,})\\/gp\\/[a-z]\\.html?.*U=([^&]*)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?amazon(?:\\.[a-z]{2,})\\/gp\\/redirect\\.html?.*location=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "aliexpress",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?aliexpress(?:\\.[a-z]{2,})",
        "completeProvider": false,
        "rules": [
            "srcSns",
            "mb",
            "tid",
            "image",
            "businessType",
            "templateId",
            "title",
            "[A-Za-z]*_?platform",
            "cpt",
            "terminal_id",
            "aff_[a-z_]+",
            "trace",
            "tt",
            "sk",
            "s",
            "spreadType",
            "tmLog",
            "bizType",
            "mergeHashcode",
            "description",
            "templateKey"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "bing",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bing\\.com",
        "completeProvider": false,
        "rules": [
            "pq",
            "toWww",
            "redig",
            "rlid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "change.org",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?change\\.org",
        "completeProvider": false,
        "rules": [
            "recruite[a-z_]+",
            "cs_tk",
            "source_location",
            "pt",
            "user_flow"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "facebook",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?facebook\\.com",
        "completeProvider": false,
        "rules": [
            "h",
            "login_source",
            "_[a-z_]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "globalRules",
        "urlPattern": ".*",
        "completeProvider": false,
        "rules": [
            "pfm_[a-zA-Z0-9]*",
            "seller[Ii]d",
            "franq",
            "opn",
            "mktportal",
            "gclsrc",
            "_*twitter_impression",
            "partner",
            "cm_mmc",
            "epar",
            "hl",
            "s_term",
            "ref_noscript"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "google",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}",
        "completeProvider": false,
        "rules": [
            "client",
            "oe",
            "docid",
            "imgrefurl",
            "amp"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/amp\\/s\\/([^&]*)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/img.+(?:\\?|&)imgurl=([^&]*)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?google(?:\\.[a-z]{2,}){1,}\\/aclk.+(?:\\?|&)adurl=([^&]*)"
        ],
        "forceRedirection": true
    },
    {
        "providerName": "kabum",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?kabum\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "zanpid",
            "codigo"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?kabum\\.com\\.br\\/cgi-local\\/site\\/produtos\\/descricao_ofertas\\.cgi\\?.+"
        ],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "mercadolibre",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mercadoli[bv]re\\.com",
        "completeProvider": false,
        "rules": [
            "matt_[a-z]+",
            "reco_[a-z]+",
            "\\bc_[a-z]+",
            "no[Ii]ndex",
            "contextual",
            "[a-zA-Z]+ariation",
            "position",
            "type",
            "tracking_id",
            "quantity",
            "reference_id"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "telefonicavivo",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?vivo\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "id_origem_vivo",
            "origin",
            "pid",
            "is_retargeting",
            "shortlink",
            "af_[a-z]+",
            "c(?:_.+)?"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "twitter",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?twitter\\.com",
        "completeProvider": false,
        "rules": [
            "original_referer",
            "via"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "globo",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?globo\\.com",
        "completeProvider": false,
        "rules": [
            "versao"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "americanas",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?americanas\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "WT\\.srch",
            "acc",
            "o",
            "i"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "duckduckgo",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?(duckduckgo\\.com)",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?duckduckgo.com\\/l\\/\\?.*uddg=([^&]*)",
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?duckduckgo\\.com\\/y\\.js\\?.*u3=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "dell",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?dell\\.com",
        "completeProvider": false,
        "rules": [
            "dgseg",
            "cid",
            "ran[a-zA-Z]",
            "gacd",
            "dgc",
            "acd",
            "lid",
            "VEN3"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "onelink",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?onelink\\.me",
        "completeProvider": false,
        "rules": [
            "af_[a-z]+",
            "pid",
            "c"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "myanimelist",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?myanimelist\\.net",
        "completeProvider": false,
        "rules": [
            "_[a-z]+",
            "from",
            "id"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "dartsearch",
        "urlPattern": "^https?:\\/\\/clickserve\\.dartsearch\\.net",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/clickserve\\.dartsearch\\.net\\/link\\/click\\?.*ds_dest_url=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "googleplay",
        "urlPattern": "^https?:\\/\\/play\\.google\\.com",
        "completeProvider": false,
        "rules": [
            "pcampaignid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "elpais",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?elpais\\.com",
        "completeProvider": false,
        "rules": [
            "ssm",
            "rel",
            "prod",
            "o",
            "prm"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "primevideo",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?primevideo\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [
            "\\/ref=[^/?]*"
        ],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "awscloud",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?awscloud\\.com",
        "completeProvider": false,
        "rules": [
            "sc_[a-z]+",
            "trk"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "natura",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?natura\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "iprom_[a-z]+",
            "list_[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [
            "consultoria"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "compracerta",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?compracerta\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "utmi_[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [
            "indicator.*"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "awin",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?awin1\\.com",
        "completeProvider": true,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?awin1\\.com\\/cread\\.php?.*ued=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "zattini",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?zattini\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "campaign"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "spotify",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?spotify\\.com",
        "completeProvider": false,
        "rules": [
            "splot"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "mozilla",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?mozilla\\.org",
        "completeProvider": false,
        "rules": [
            "redirect[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "cooldeal",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?cooldeal\\.by",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?cooldeal\\.by\\/redirect\\/.*to=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "bbc",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?bbc\\.com",
        "completeProvider": false,
        "rules": [
            "ns_[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "vk",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?vk\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?vk\\.com\\/away\\.php?.*to=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "medium",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?medium\\.com",
        "completeProvider": false,
        "rules": [
            "sectionName"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "gp",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?play\\.app\\.goo\\.gl",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?play\\.app\\.goo\\.gl\\/?.*link=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "netshoes",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?netshoes\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "af_.+",
            "clickid",
            "pid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "hurb",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?hurb\\.com",
        "completeProvider": false,
        "rules": [
            "cmp"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?hurb\\.com\\/aud\\/([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "submarino",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?submarino\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "chave"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "girafa",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?girafa\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "lmdsid"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "iqbroker",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?iqbroker\\.co",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [
            "af[a-z_]+",
            "pid",
            "c"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "extra",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?extra\\.com\\.br",
        "completeProvider": false,
        "rules": [
            "IdSku"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "crunchyroll",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?crunchyroll\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [
            "from"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "deezer",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?deezer\\.com",
        "completeProvider": false,
        "rules": [
            "redirect_[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "banggood",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?banggood\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [
            "zf",
            "_branch_match_id"
        ],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "awsevents",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?awsevents\\.com",
        "completeProvider": false,
        "rules": [
            "trk[a-zA-Z]*",
            "sc_[a-z]+"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "ubi",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?ubi\\.com",
        "completeProvider": false,
        "rules": [
            "cache"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    },
    {
        "providerName": "allshops",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?allshops\\.me",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?allshops\\.me\\/redirect\\/.+to=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "shareasale",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?shareasale\\.com",
        "completeProvider": false,
        "rules": [],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [
            "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?shareasale\\.com\\/r\\.cfm.+urllink=([^&]*)"
        ],
        "forceRedirection": false
    },
    {
        "providerName": "udemy",
        "urlPattern": "^https?:\\/\\/(?:[a-z0-9-]+\\.)*?udemy\\.com",
        "completeProvider": false,
        "rules": [
            "ran[A-Za-z]+",
            "LSNPUBID"
        ],
        "rawRules": [],
        "referralMarketing": [],
        "exceptions": [],
        "redirections": [],
        "forceRedirection": false
    }
]
let redirectsNode*: JsonNode = %* [
    {
        "providerName": "global",
        "urlPattern": ".*",
        "domains": [],
        "rules": [
            "redirecturl\\s\\=\\s'(https?:\\/\\/.+)'"
        ]
    }
]
