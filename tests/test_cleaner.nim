import ../src/unalix

var unmodifiedUrl: string

unmodifiedUrl = "https://deezer.com/track/891177062?utm_source=deezer"

doAssert clearUrl(unmodifiedUrl) == "https://deezer.com/track/891177062"
doAssert clearUrl(unmodifiedUrl, ignoreRules = true) == unmodifiedUrl

unmodifiedUrl = "https://www.google.com/url?q=https://pypi.org/project/Unalix"

doAssert clearUrl(unmodifiedUrl) == "https://pypi.org/project/Unalix"
doAssert clearUrl(unmodifiedUrl, ignoreRedirections = true) == unmodifiedUrl

unmodifiedUrl = "https://www.google.com/amp/s/de.statista.com/infografik/amp/22496/anzahl-der-gesamten-positiven-corona-tests-und-positivenrate/"
doAssert clearUrl(unmodifiedUrl) == "http://de.statista.com/infografik/amp/22496/anzahl-der-gesamten-positiven-corona-tests-und-positivenrate/"

unmodifiedUrl = "http://www.shareasale.com/r.cfm?u=1384175&b=866986&m=65886&afftrack=&urllink=www.rightstufanime.com%2Fsearch%3Fkeywords%3DSo%20I%27m%20a%20Spider%20So%20What%3F"
doAssert clearUrl(unmodifiedUrl) == "http://www.rightstufanime.com/search?keywords=So%20I'm%20a%20Spider%20So%20What%3F"

unmodifiedUrl = "https://www.amazon.com/gp/B08CH7RHDP/ref=as_li_ss_tl"

doAssert clearUrl(unmodifiedUrl) == "https://www.amazon.com/gp/B08CH7RHDP"
doAssert clearUrl(unmodifiedUrl, ignoreRawRules = true) == unmodifiedUrl

unmodifiedUrl = "https://natura.com.br/p/2458?consultoria=promotop"

doAssert clearUrl(unmodifiedUrl) == "https://natura.com.br/p/2458"
doAssert clearUrl(unmodifiedUrl, ignoreReferralMarketing = true) == unmodifiedUrl

unmodifiedUrl = "https://myaccount.google.com/?utm_source=google"

doAssert clearUrl(unmodifiedUrl) == unmodifiedUrl
doAssert clearUrl(unmodifiedUrl, ignoreExceptions = true) == "https://myaccount.google.com/"

unmodifiedUrl = "http://clickserve.dartsearch.net/link/click?ds_dest_url=http://g.co/"

doAssert clearUrl(unmodifiedUrl) == "http://g.co/"
doAssert clearUrl(unmodifiedUrl, skipBlocked = true) == unmodifiedUrl

unmodifiedUrl = "http://example.com/?p1=&p2="

doAssert clearUrl(unmodifiedUrl) == unmodifiedUrl
doAssert clearUrl(unmodifiedUrl, stripEmpty = true) == "http://example.com/"

unmodifiedUrl = "http://example.com/?p1=value&p1=othervalue"

doAssert clearUrl(unmodifiedUrl) == unmodifiedUrl
doAssert clearUrl(unmodifiedUrl, stripDuplicates = true) == "http://example.com/?p1=value"

unmodifiedUrl = "http://example.com/?&&&&"

doAssert clearUrl(unmodifiedUrl) == "http://example.com/"
