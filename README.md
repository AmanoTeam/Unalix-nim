# Unalix

Unalix is a library and CLI tool written in Nim, it implements the specification used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon for removing tracking fields from URLs.

## Installation

Install using `nimble`:

```bash
nimble install --accept 'unalix'
```

_**Note**: Unalix requires Nim 1.4.0 or higher._

## Usage:

Removing tracking fields:

```nim
import unalix

const url: string = "https://deezer.com/track/891177062?utm_source=deezer"
let result: string = clearUrl(url = url)

assert result == "https://deezer.com/track/891177062"
```

Resolving shortened URL:

```nim
import unalix

const url: string = "https://bitly.is/Pricing-Pop-Up"
let result: string = unshortUrl(url = url)

assert result == "https://bitly.com/pages/pricing"
```

_**Tip**: The `unshortUrl()` proc will strip tracking fields from any URL before following a redirect, so you don't need to manually call `clearUrl()` for it's return value._

## Downloads

You can get prebuilt static executables of the CLI tool for Linux and Android [here](https://github.com/AmanoTeam/UnalixLibs).

## Contributing

If you have discovered a bug in this library and know how to fix it, fork this repository and open a Pull Request.

## Third party software

Unalix includes some third party software in its codebase. See them below:

- **ClearURLs**
  - Author: Kevin Röbert
  - Repository: [ClearURLs/Rules](https://github.com/ClearURLs/Rules)
  - License: [GNU Lesser General Public License v3.0](https://gitlab.com/ClearURLs/Rules/blob/master/LICENSE)

- **Requests**
  - Author: Kenneth Reitz
  - Repository: [psf/requests](https://github.com/psf/requests)
  - License: [Apache v2.0](https://github.com/psf/requests/blob/master/LICENSE)

- **libandroid-glob**
  - Author: Many authors
  - Repository: [termux/termux-packages](https://github.com/termux/termux-packages/tree/master/packages/libandroid-glob)
  - License: [BSD 3-Clause](https://github.com/termux/termux-packages/blob/master/packages/libandroid-glob/LICENSE)
