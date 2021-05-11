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

let url = "https://deezer.com/track/891177062?utm_source=deezer"
let result = clearUrl(url)

echo result
```

Unshortening a shortened URL:

```nim
import unalix

let url = "https://bitly.is/Pricing-Pop-Up"
let result = unshortUrl(url)

echo result
```

Output from both examples:

```
https://deezer.com/track/891177062
https://bitly.com/pages/pricing
```

##### CLI Usage:

`{ tee /dev/tty ; echo '======' > /dev/tty }` just prints the input to the terminal, so that we can see both the input and the output. You do not need to use it in your own scripts.

``` zsh
❯ echo 'https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiY2ZrqxsHwAhXhB2MBHda6BUsQFjAJegQIBBAD&url=https%3A%2F%2Fapps.apple.com%2Fus%2Fapp%2Finspect-browser%2Fid1203594958&usg=AOvVaw2O_zES4FcNiKDn0veAc1bM'$'\n''https://www.imdb.com/title/tt7979580/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=ea4e08e1-c8a3-47b5-ac3a-75026647c16e&pf_rd_r=J6DRF89QKAFZ76S5FZYE&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=moviemeter&ref_=chtmvm_tt_1'$'\n''https://bitly.is/Pricing-Pop-Up' | { tee /dev/tty ; echo '======' > /dev/tty } | unalix
```

```
https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiY2ZrqxsHwAhXhB2MBHda6BUsQFjAJegQIBBAD&url=https%3A%2F%2Fapps.apple.com%2Fus%2Fapp%2Finspect-browser%2Fid1203594958&usg=AOvVaw2O_zES4FcNiKDn0veAc1bM
https://www.imdb.com/title/tt7979580/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=ea4e08e1-c8a3-47b5-ac3a-75026647c16e&pf_rd_r=J6DRF89QKAFZ76S5FZYE&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=moviemeter&ref_=chtmvm_tt_1
https://bitly.is/Pricing-Pop-Up
======
https://apps.apple.com/us/app/inspect-browser/id1203594958
https://www.imdb.com/title/tt7979580/
https://bitly.is/Pricing-Pop-Up
```

``` zsh
❯ echo 'https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiY2ZrqxsHwAhXhB2MBHda6BUsQFjAJegQIBBAD&url=https%3A%2F%2Fapps.apple.com%2Fus%2Fapp%2Finspect-browser%2Fid1203594958&usg=AOvVaw2O_zES4FcNiKDn0veAc1bM'$'\n''https://www.imdb.com/title/tt7979580/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=ea4e08e1-c8a3-47b5-ac3a-75026647c16e&pf_rd_r=J6DRF89QKAFZ76S5FZYE&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=moviemeter&ref_=chtmvm_tt_1'$'\n''https://bitly.is/Pricing-Pop-Up' | { tee /dev/tty ; echo '======' > /dev/tty } | unalix --unshort
```

```
https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&ved=2ahUKEwiY2ZrqxsHwAhXhB2MBHda6BUsQFjAJegQIBBAD&url=https%3A%2F%2Fapps.apple.com%2Fus%2Fapp%2Finspect-browser%2Fid1203594958&usg=AOvVaw2O_zES4FcNiKDn0veAc1bM
https://www.imdb.com/title/tt7979580/?pf_rd_m=A2FGELUUNOQJNL&pf_rd_p=ea4e08e1-c8a3-47b5-ac3a-75026647c16e&pf_rd_r=J6DRF89QKAFZ76S5FZYE&pf_rd_s=center-1&pf_rd_t=15506&pf_rd_i=moviemeter&ref_=chtmvm_tt_1
https://bitly.is/Pricing-Pop-Up
======
https://apps.apple.com/us/app/inspect-browser/id1203594958
https://www.imdb.com/title/tt7979580/
https://bitly.com/pages/pricing
```

#### Building from source

``` zsh
git clone --recursive https://github.com/AmanoTeam/Unalix-nim
cd ./Unalix-nim

nimble install --verbose -y
```

You might need to repeat the last step on the first installation.

#### Contributing

If you have discovered a bug in this library and know how to fix it, fork this repository and open a Pull Request.

If you found a URL that was not fully cleaned by Unalix (e.g some tracking fields still remains), report them here or in the [ClearURLs addon repository](https://github.com/ClearURLs/Addon/issues). We use the list of regex rules maintained by the ClearURLs maintainers, but we also have our [own list](https://github.com/AmanoTeam/Unalix-nim/blob/master/unalix/package_data/unalix-data.min.json).

#### Third party software

Unalix includes some third party software. See them below:

- **ClearURLs**
  - Author: Kevin Röbert
  - Repository: [ClearURLs/Addon](https://github.com/ClearURLs/Addon)
  - License: [GNU Lesser General Public License v3.0](https://gitlab.com/ClearURLs/Addon/blob/master/LICENSE)
