import argparse
import io

parser = argparse.ArgumentParser(
    prog="unalix",
    description="Unalix is a small, dependency-free, fast Nim package (and CLI tool) for removing tracking fields from URLs.",
    allow_abbrev=False,
    epilog="When no URLs are supplied, default action is to read from standard input."
)

parser.add_argument(
	"-v",
    "--version",
    action="store_true",
    help="show version number and exit."
)

parser.add_argument(
	"-u",
    "--url",
	required=True,
    help="HTTP URL you want to unshort or remove tracking fields from (default: read from stdin)"
)

parser.add_argument(
    "--ignore-referral",
    action="store_true",
    help="instruct Unalix to not remove referral marketing fields from the given URL."
)

parser.add_argument(
    "--ignore-rules",
    action="store_true",
    help="instruct Unalix to not remove tracking fields from the given URL."
)

parser.add_argument(
    "--ignore-exceptions",
    action="store_true",
    help="instruct Unalix to ignore exceptions for the given URL."
)

parser.add_argument(
    "--ignore-raw-rules",
    action="store_true",
    help="instruct Unalix to ignore raw rules for the given URL."
)

parser.add_argument(
    "--ignore-redirections",
    action="store_true",
    help="instruct Unalix to ignore redirection rules for the given URL."
)

parser.add_argument(
    "--skip-blocked",
    action="store_true",
    help="instruct Unalix to not process rules for blocked URLs."
)

parser.add_argument(
    "--strip-duplicates",
    action="store_true",
    help="instruct Unalix to strip fields with duplicate names."
)

parser.add_argument(
    "--strip-empty",
    action="store_true",
    help="instruct Unalix to strip fields with empty values."
)

parser.add_argument(
	"-s",
    "--unshort",
    action="store_true",
    help="unshort the given URL (HTTP requests will be made)."
)

parser.add_argument(
	"-l",
    "--launch",
    action="store_true",
    help="launch URL with user's default browser."
)

print("Saving to ./cmd.txt")

with open(file="./cmd.txt", mode="w") as file:
	parser.print_help(file=file)