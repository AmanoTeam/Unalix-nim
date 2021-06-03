Unalix is a library written in Nim, it follows the same specification used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon for removing tracking fields from URLs.

#### Installation

Install using `nimble`:

```bash
nimble install --accept 'unalix'
```

#### Library usage:

Removing tracking fields:

```nim
import unalix/core/url_cleaner

const url: string = "https://deezer.com/track/891177062?utm_source=deezer"
let result: string = clearUrl(url)

doAssert result == "https://deezer.com/track/891177062"
```

#### CLI usage:

```bash
unalix --url 'https://deezer.com/track/891177062?utm_source=deezer'
```

Output:

```
https://deezer.com/track/891177062
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
