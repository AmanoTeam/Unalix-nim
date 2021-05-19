import argparse
import io


text1 = """\
const helpMessage: string = \"\"\"
{}
\"\"\"
const versionNumber: string = "Unalix v0.2\\n"
const longNoVal: seq[string] = @[ ## Long options that doesn't require values
    "ignore-referral",
    "ignore-rules",
    "ignore-exceptions",
    "ignore-raw-rules",
    "ignore-redirections",
    "skip-blocked",
    "strip-duplicates",
    "strip-empty",
    "unshort",
    "launch-in-browser",
    "help",
    "version"
]
const longVal: seq[string] = @[ ## Long options that require values
    "url"
]\
"""


parser = argparse.ArgumentParser(
    prog="unalix",
    description="Unalix is a small, dependency-free, fast Nim package (and CLI tool) for removing tracking fields from URLs.",
    allow_abbrev=False,
    epilog="When no URLs are supplied, default action is to read from standard input."
)

parser.add_argument(
    '--version',
    action='store_true',
    help='show version number and exit.'
)

parser.add_argument(
    '--url', required=True,
    help='HTTP URL you want to unshort or remove tracking fields from (default: read from stdin)'
)

parser.add_argument(
    '--ignore-referral',
    action='store_true',
    help='instruct Unalix to not remove referral marketing fields from the given URL.'
)

parser.add_argument(
    '--ignore-rules',
    action='store_true',
    help='instruct Unalix to not remove tracking fields from the given URL.'
)

parser.add_argument(
    '--ignore-exceptions',
    action='store_true',
    help='instruct Unalix to ignore exceptions for the given URL.'
)

parser.add_argument(
    '--ignore-raw-rules',
    action='store_true',
    help='instruct Unalix to ignore raw rules for the given URL.'
)

parser.add_argument(
    '--ignore-redirections',
    action='store_true',
    help='instruct Unalix to ignore redirection rules for the given URL.'
)

parser.add_argument(
    '--skip-blocked',
    action='store_true',
    help="instruct Unalix to not process rules for blocked URLs."
)

parser.add_argument(
    '--strip-duplicates',
    action='store_true',
    help="instruct Unalix to strip fields with duplicate names."
)

parser.add_argument(
    '--strip-empty',
    action='store_true',
    help="instruct Unalix to strip fields with empty values."
)

parser.add_argument(
    '--unshort',
    action='store_true',
    help="unshort the given URL (HTTP requests will be made)."
)

parser.add_argument(
    '--launch-in-browser',
    action='store_true',
    help="launch URL with user's default browser."
)

string_io = io.StringIO()

parser.print_help(file=string_io)
string_io.seek(0)

text2 = string_io.read().replace("[-h]", "[--help]").replace("-h, --help        show this help", "--help            show this help").replace("exit\n", "exit.\n")

with open(file="src/unalixpkg/config/cli.nim", mode="w") as file:
    file.write(text1.format(text2.strip("\n")))

