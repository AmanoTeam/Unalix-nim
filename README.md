Unalix is a small, dependency-free, fast Nim package (and CLI tool) that implements the same regex rule processing mechanism used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon.

This is a Nim port from [Unalix](https://github.com/AmanoTeam/Unalix). Python package

#### Installation

Install using `nimble`:

```bash
$ nimble install --accept \
    'git://github.com/AmanoTeam/Unalix-nim'
```

#### Library usage:

Removing tracking fields:

```nim
import unalix/core/url_cleaner

const url: string = "https://deezer.com/track/891177062?utm_source=deezer"
let result: string = clearUrl(url)

echo result
```

Unshort shortened URL:

```nim
import unalix/core/url_unshort

const url: string = "https://bitly.is/Pricing-Pop-Up"
let result: string = unshortUrl(url)

echo result
```

Output from both examples:

```
https://deezer.com/track/891177062
https://bitly.com/pages/pricing
```

#### CLI usage:

```bash
$ unalix --unshort << heredoc
https://deezer.com/track/891177062?utm_source=deezer
https://bitly.is/Pricing-Pop-Up
heredoc
```

Output:

```
https://deezer.com/track/891177062
https://bitly.com/pages/pricing
```

_Run `unalix --help` to see the list of arguments_

#### Contributing

If you have discovered a bug in this library and know how to fix it, fork this repository and open a Pull Request.

If you found a URL that was not fully cleaned by Unalix (e.g. some tracking fields still remains), report them here or in the [ClearURLs rules repository](https://gitlab.com/anti-tracking/ClearURLs/rules/-/issues). We use the list of regex rules maintained by the ClearURLs maintainers, but we also have our [own list](https://github.com/AmanoTeam/Unalix/blob/master/unalix/package_data/rulesets/unalix.json).

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
