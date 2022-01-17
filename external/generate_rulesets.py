import json
import http.client
import urllib.parse

text = """\
import json

let rulesetsNode*: JsonNode = %* {}
let redirectsNode*: JsonNode = %* {}
"""

rulesets = []

urls = (
	"https://rules1.clearurls.xyz/data/data.minify.json",
	"https://raw.githubusercontent.com/AmanoTeam/Unalix/master/unalix/package_data/rulesets/unalix.json",
	"https://raw.githubusercontent.com/AmanoTeam/Unalix/master/unalix/package_data/other/redirects_from_body.json"
)

ignored_providers = (
    "ClearURLsTest",
    "ClearURLsTestBlock",
    "ClearURLsTest2",
    "ClearURLsTestBlock2"
)


for raw_url in urls:
	print(f"Fetching data from {raw_url}...")

	url = urllib.parse.urlparse(url = raw_url)

	connection = http.client.HTTPSConnection(
		host = url.netloc,
		port = url.port
	)

	connection.request(
		method = "GET",
		url = url.path
	)
	response = connection.getresponse()
	content = response.read()
	
	connection.close()

	rules = json.loads(s = content)
	
	if raw_url.endswith("redirects_from_body.json"):
		redirects = rules
		continue

	for providerName in rules["providers"].keys():
		if not rules["providers"][providerName]["urlPattern"]:
			continue

		if providerName in ignored_providers:
			continue

		rulesets.append({
			"providerName": providerName,
			"urlPattern": rules["providers"][providerName]["urlPattern"],
			"completeProvider": rules["providers"][providerName].get("completeProvider", False),
			"rules": rules["providers"][providerName].get("rules", []),
			"rawRules": rules["providers"][providerName].get("rawRules", []),
			"referralMarketing": rules["providers"][providerName].get("referralMarketing", []),
			"exceptions": rules["providers"][providerName].get("exceptions", []),
			"redirections": rules["providers"][providerName].get("redirections", []),
			"forceRedirection": rules["providers"][providerName].get("forceRedirection", False)
		})

with open(file = "src/unalixpkg/rulesets.nim", mode = "w") as file:
	file.write(
		text.format(
			json.dumps(obj = rulesets, ensure_ascii = False, indent = 4),
			json.dumps(obj = redirects, ensure_ascii = False, indent = 4)
		)
	)
