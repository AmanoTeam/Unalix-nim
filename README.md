Unalix is a library and CLI tool written in Nim, it follows the same specification used by the [ClearURLs](https://github.com/ClearURLs/Addon) addon for removing tracking fields from URLs.

#### Installation

Install using `nimble`:

```bash
nimble install --accept 'unalix'
```

_**Note**: Unalix requires Nim 1.4.0 or higher._

#### Usage:

Removing tracking fields:

```nim
import unalix

const url: string = "https://deezer.com/track/891177062?utm_source=deezer"
let result: string = clearUrl(url = url)

assert result == "https://deezer.com/track/891177062"
```

Unshort shortened URL:

```nim
import unalix

const url: string = "https://bitly.is/Pricing-Pop-Up"
let result: string = unshortUrl(url = url)

assert result == "https://bitly.com/pages/pricing"
```

_**Tip**: The `unshortUrl()` proc will strip tracking fields from any URL before following a redirect, so you don't need to manually call `clear_url()` for it's return value._

#### C API

You can easily integrate this library into your native C/C++ app. Have a look at [Nim invocation example from C](https://nim-lang.org/docs/backends.html#backend-code-calling-nim-nim-invocation-example-from-c) for more information.

#### C API usage

Removing tracking fields:

```c
#include "unalix.h"
#include <assert.h>
#include <string.h>

int main() {

    const char url[] = "https://deezer.com/track/891177062?utm_source=deezer";
    const int ignoreReferralMarketing = 0;
    const int ignoreRules = 0;
    const int ignoreExceptions = 0;
    const int ignoreRawRules = 0;
    const int ignoreRedirections = 0;
    const int skipBlocked = 0;
    const int stripDuplicates = 0;
    const int stripEmpty = 0;

    // Call this once after loading the library
    NimMain();

    char* result = clearUrl(
        url,
        ignoreReferralMarketing,
        ignoreRules,
        ignoreExceptions,
        ignoreRawRules,
        ignoreRedirections,
        skipBlocked,
        stripDuplicates,
        stripEmpty
    );

    assert(strcmp(result, "https://deezer.com/track/891177062") == 0);

}
```

Unshort shortened URL:

```c
#include "unalix.h"
#include <assert.h>
#include <string.h>

int main() {

    const char url[] = "https://bitly.is/Pricing-Pop-Up";
    const int ignoreReferralMarketing = 0;
    const int ignoreRules = 0;
    const int ignoreExceptions = 0;
    const int ignoreRawRules = 0;
    const int ignoreRedirections = 0;
    const int skipBlocked = 0;
    const int stripDuplicates = 0;
    const int stripEmpty = 0;

    // Call this once after loading the library
    NimMain();

    char* result = unshortUrl(
        url,
        ignoreReferralMarketing,
        ignoreRules,
        ignoreExceptions,
        ignoreRawRules,
        ignoreRedirections,
        skipBlocked,
        stripDuplicates,
        stripEmpty
    );

    assert(strcmp(result, "https://bitly.com/pages/pricing") == 0);

}
```

1. Generate sources (change from `c` to `cpp` to generate C++ sources instead):

```bash
nim c \
    --noMain \
    --compileOnly:on \
    --header:'unalix.h' \
    'src/unalixpkg/core.nim'
```

2. Put one of the examples in a file called `testUnalix.c` and compile with:

```bash
gcc -o './testUnalix' \
    -I"${HOME}/.cache/nim/core_d" \
    -I'/path/to/nim/lib' \
    "${HOME}/.cache/nim/core_d/"*.c \
    'testUnalix.c'
```

3. Now run the compiled `./testUnalix`

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
