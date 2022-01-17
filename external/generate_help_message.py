import argparse

parser = argparse.ArgumentParser(
    prog = "unalix",
    description = None,
    allow_abbrev = False,
    epilog = "Note, options that take an argument require a colon. E.g. -u:URL"
)

parser.add_argument(
    "-v",
    "--version",
    action = "store_true",
    help = "show version number and exit"
)

parser.add_argument(
    "-u",
    "--url",
    required = True,
    help = "HTTP URL"
)

parser.add_argument(
    "--ignore-referral",
    action = "store_true",
    help = "Don't strip referral marketing fields"
)

parser.add_argument(
    "--ignore-generic",
    action = "store_true",
    help = "Don't strip generic tracking fields"
)

parser.add_argument(
    "--ignore-exceptions",
    action = "store_true",
    help = "Ignore rule exceptions"
)

parser.add_argument(
    "--ignore-raw",
    action = "store_true",
    help = "Don't strip raw tracking elements"
)

parser.add_argument(
    "--ignore-redirections",
    action = "store_true",
    help = "Ignore redirection rules"
)

parser.add_argument(
    "--skip-blocked",
    action = "store_true",
    help = "Ignore rule processing for blocked URLs"
)

parser.add_argument(
    "--strip-duplicates",
    action = "store_true",
    help = "Strip fields with duplicate names. (might break the URL!)"
)

parser.add_argument(
    "--strip-empty",
    action = "store_true",
    help = "Strip fields with empty values. (might break the URL!)"
)

parser.add_argument(
    "--parse-documents",
    action = "store_true",
    help = "Look for redirect URLs in the response body when there is no HTTP redirect to follow"
)

parser.add_argument(
    "-s",
    "--unshort",
    action = "store_true",
    help = "Unshort the given URL (HTTP requests will be made)"
)

parser.add_argument(
    "-l",
    "--launch-with-browser",
    action = "store_true",
    help = "Open URL with default browser"
)

parser.add_argument(
    "--strict-errors",
    action = "store_true",
    help = "Turn errors into fatal exceptions"
)

http_parser = parser.add_argument_group(
    title = "HTTP settings"
)

http_parser.add_argument(
    "--timeout",
    type = int,
    help = "Max timeout in seconds"
)

http_parser.add_argument(
    "--max-redirects",
    type = int,
    help = "Max number of allowed redirects"
)

print("Saving to ./help_message.txt")

with open(file = "./help_message.txt", mode = "w") as file:
    parser.print_help(file = file)