import argparse
import io

parser = argparse.ArgumentParser(
    prog="unalix",
    description="Unalix is a small, dependency-free, fast Nim package and CLI tool for removing tracking fields from URLs.",
    allow_abbrev=False
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
    help="HTTP URL you want to unshort or remove tracking fields from.  [default: read from standard input]"
)

parser.add_argument(
    "--ignore-referral",
    action="store_true",
    help="Instruct Unalix to not remove referral marketing fields from the given URL.  [default: remove]"
)

parser.add_argument(
    "--ignore-rules",
    action="store_true",
    help="Instruct Unalix to not remove tracking fields from the given URL.  [default: don't ignore]"
)

parser.add_argument(
    "--ignore-exceptions",
    action="store_true",
    help="Instruct Unalix to ignore exceptions for the given URL.  [default: don't ignore]"
)

parser.add_argument(
    "--ignore-raw-rules",
    action="store_true",
    help="Instruct Unalix to ignore raw rules for the given URL.  [default: don't ignore]"
)

parser.add_argument(
    "--ignore-redirections",
    action="store_true",
    help="Instruct Unalix to ignore redirection rules for the given URL.  [default: don't ignore]"
)

parser.add_argument(
    "--skip-blocked",
    action="store_true",
    help="Instruct Unalix to ignore rule processing for blocked URLs.  [default: don't ignore]"
)

parser.add_argument(
    "--strip-duplicates",
    action="store_true",
    help="Instruct Unalix to strip fields with duplicate names.  [default: don't strip]"
)

parser.add_argument(
    "--strip-empty",
    action="store_true",
    help="Instruct Unalix to strip fields with empty values.  [default: don't strip]"
)

parser.add_argument(
	"-s",
    "--unshort",
    action="store_true",
    help="Unshort the given URL (HTTP requests will be made).  [default: don't try to unshort]"
)

parser.add_argument(
	"-l",
    "--launch",
    action="store_true",
    help="Launch URL with user's default browser.  [default: don't launch]"
)

print("Saving to ./cmd.txt")

with open(file="./cmd.txt", mode="w") as file:
	parser.print_help(file=file)