Unalix is a library and CLI tool written in Nim, it follows the same specification used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon for removing tracking fields from URLs.

#### Installation

Install using `nimble`:

```bash
nimble install --accept 'unalix'
```

_**Note**: Unalix requires Nim 1.2.0 or higher._

#### Library usage

```nim
import unalix

var
  url: string

url = "https://deezer.com/track/891177062?utm_source=deezer"

# Strip tracking fields
assert clearUrl(url = url) == "https://deezer.com/track/891177062"

url = "https://bitly.is/Pricing-Pop-Up"

# Unshort shortened URL
assert unshortUrl(url = url) == "https://bitly.com/pages/pricing"
```

_**Tip**: The `unshortUrl()` proc will strip tracking fields from any URL before following a redirect, so you don't need to manually call `clearUrl()` for it's return value._

#### CLI tool usage

```
$ unalix --help
usage: unalix [-h] [-v] -u URL
              [--ignore-referral]
              [--ignore-rules]
              [--ignore-exceptions]
              [--ignore-raw-rules]
              [--ignore-redirections]
              [--skip-blocked]
              [--strip-duplicates]
              [--strip-empty] [-s] [-l]

Unalix is a small, dependency-free, fast
Nim package and CLI tool for removing
tracking fields from URLs.

optional arguments:
  -h, --help        show this help
                    message and exit
  -v, --version     show version number
                    and exit
  -u URL, --url URL
                    HTTP URL you want to
                    unshort or remove
                    tracking fields
                    from. [default: read
                    from standard input]
  --ignore-referral
                    Instruct Unalix to
                    not remove referral
                    marketing fields
                    from the given URL.
                    [default: remove]
  --ignore-rules    Instruct Unalix to
                    not remove tracking
                    fields from the
                    given URL. [default:
                    don't ignore]
  --ignore-exceptions
                    Instruct Unalix to
                    ignore exceptions
                    for the given URL.
                    [default: don't
                    ignore]
  --ignore-raw-rules
                    Instruct Unalix to
                    ignore raw rules for
                    the given URL.
                    [default: don't
                    ignore]
  --ignore-redirections
                    Instruct Unalix to
                    ignore redirection
                    rules for the given
                    URL. [default: don't
                    ignore]
  --skip-blocked    Instruct Unalix to
                    ignore rule
                    processing for
                    blocked URLs.
                    [default: don't
                    ignore]
  --strip-duplicates
                    Instruct Unalix to
                    strip fields with
                    duplicate names.
                    [default: don't
                    strip]
  --strip-empty     Instruct Unalix to
                    strip fields with
                    empty values.
                    [default: don't
                    strip]
  -s, --unshort     Unshort the given
                    URL (HTTP requests
                    will be made).
                    [default: don't try
                    to unshort]
  -l, --launch      Launch URL with
                    user's default
                    browser. [default:
                    don't launch]
```

#### Contributing

If you have discovered a bug in this library and know how to fix it, fork this repository and open a Pull Request.

#### Third party software

Unalix includes some third party software in its codebase. See them below:

- **ClearURLs**
  - Author: Kevin Röbert
  - Repository: [ClearURLs/Rules](https://github.com/ClearURLs/Rules)
  - License: [GNU Lesser General Public License v3.0](https://gitlab.com/ClearURLs/Rules/blob/master/LICENSE)

- **Requests**
  - Author: Kenneth Reitz
  - Repository: [psf/requests](https://github.com/psf/requests)
  - License: [Apache v2.0](https://github.com/psf/requests/blob/master/LICENSE)
