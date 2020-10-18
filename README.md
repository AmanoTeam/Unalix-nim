Unalix is a simple code library written in Nim. It implements the same regex rule processing mechanism used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon.

#### Installation

Install using `nimble`:

```bash
nimble install --accept "git://github.com/AmanoTeam/Unalix-nim"
```

#### Usage:

Removing tracking fields:

```nim
import unalix

var
  url, result: string

url = "https://deezer.com/track/891177062?utm_source=deezer"
result = clearUrl(url)

echo result
```

Unshortening a shortened URL:

```nim
import unalix

var
  url, result: string

url = "https://bitly.is/Pricing-Pop-Up"
result = unshortUrl(url)

echo result
```

Output from both examples:

```
https://deezer.com/track/891177062
https://bitly.com/pages/pricing
```

#### Contributing

If you have discovered a bug in this library and know how to fix it, fork this repository and open a Pull Request.

If you found a URL that was not fully cleaned by Unalix (e.g some tracking fields still remains), report them here or in the [ClearURLs addon repository](https://github.com/ClearURLs/Addon/issues). We use the list of regex rules maintained by the ClearURLs maintainers, but we also have our [own list](https://github.com/AmanoTeam/Unalix-nim/blob/master/unalix/package_data/unalix-data.min.json).

#### Third party software

Unalix includes some third party software. See them below:

- **ClearURLs**
  - Author: Kevin Röbert
  - Repository: [ClearURLs/Addon](https://github.com/ClearURLs/Addon)
  - License: [GNU Lesser General Public License v3.0](https://gitlab.com/ClearURLs/Addon/blob/master/LICENSE)
