import argparse

parser = argparse.ArgumentParser(
    prog="unalix",
    description="Unalix is a small, dependency-free, fast Nim package and CLI tool for removing tracking fields from URLs.",
    allow_abbrev=False,
    epilog="Note, options that take an argument require a colon. E.g. -u:URL."
)

parser.add_argument(
	"-v",
    "--version",
    action="store_true",
    help="show version number and exit"
)

parser.add_argument(
	"-u",
    "--url",
	required=True,
    help="HTTP URL you want to unshort or remove tracking fields from.  [default: read from stdin]"
)

parser.add_argument(
    "--ignore-referral",
    action="store_true",
    help="Don't strip referral marketing fields."
)

parser.add_argument(
    "--ignore-generic",
    action="store_true",
    help="Ignore generic rules."
)

parser.add_argument(
    "--ignore-exceptions",
    action="store_true",
    help="Ignore rule exceptions."
)

parser.add_argument(
    "--ignore-raw",
    action="store_true",
    help="Ignore raw rules."
)

parser.add_argument(
    "--ignore-redirections",
    action="store_true",
    help="Ignore redirection rules."
)

parser.add_argument(
    "--skip-blocked",
    action="store_true",
    help="Ignore rule processing for blocked URLs."
)

parser.add_argument(
    "--strip-duplicates",
    action="store_true",
    help="Strip fields with duplicate names. (might break the URL!)"
)

parser.add_argument(
    "--strip-empty",
    action="store_true",
    help="Strip fields with empty values. (might break the URL!)"
)

parser.add_argument(
    "--parse-documents",
    action="store_true",
    help="Look for redirect URLs in the response body when there is no HTTP redirect to follow."
)

parser.add_argument(
	"-s",
    "--unshort",
    action="store_true",
    help="Unshort the given URL (HTTP requests will be made)."
)

parser.add_argument(
	"-l",
    "--launch",
    action="store_true",
    help="Launch URL(s) with default browser."
)

parser_group = parser.add_argument_group(title="HTTP settings", description="Arguments from this group only takes effect when --unshort is set.")

parser_group.add_argument(
    "--http-method",
    help="Default HTTP method for requests.  [default: GET]",
    metavar="METHOD"
)

parser_group.add_argument(
    "--http-max-redirects",
    help="Max number of HTTP redirects to follow before raising an exception.  [default: 13]",
    metavar="MAX_REDIRECTS"
)

parser_group.add_argument(
    "--http-max-timeout",
    help="Max number of seconds to wait for a response before raising an exception.  [default: 3]",
    metavar="MAX_TIMEOUT"
)

parser_group.add_argument(
    "--http-max-fetch-size",
    help="Max number of bytes to fetch from responses body. Only takes effect when --parse-documents is set.  [default: 1048576]",
    metavar="MAX_FETCH_SIZE"
)

parser_group.add_argument(
    "--http-max-retries",
    help="Max number of times to retry on connection errors.  [default: 0]",
    metavar="MAX_RETRIES"
)

parser_group.add_argument(
    "--disable-certificate-validation",
    help="Disable TLS certificates validation",
    action="store_true",
)

print("Saving to ./cmd.txt")

with open(file="./cmd.txt", mode="w") as file:
	parser.print_help(file=file)