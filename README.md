Unalix is a library written in Nim, it follows the same specification used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon for removing tracking fields from URLs.

#### Installation

Install using `nimble`:

```bash
nimble install --accept 'unalix'
```

The version from the `master` branch might be broken sometimes, but you can also install from it:

```bash
nimble install --accept 'git://github.com/AmanoTeam/Unalix-nim.git'
```

_**Note**: Unalix requires Nim 1.2.0 or higher._

#### Usage:

Library:

```nim
import unalix

const url: string = "https://deezer.com/track/891177062?utm_source=deezer"
let result: string = clearUrl(url)

echo result
```

CLI tool:

```bash
unalix --url 'https://deezer.com/track/891177062?utm_source=deezer'
```

Output from both examples:

```
https://deezer.com/track/891177062
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
