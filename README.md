# k.iosevka

A custom build of [Iosevka](https://typeof.net/Iosevka/) for personal use. A
preview of the typeface can be found at [Julia as a CLI
calculator](https://krasjet.com/rnd.wlk/julia/).

![preview](./preview.png)
![preview-italic](./preview-italic.png)

## Build

Compiled fonts can be found on the
[release](https://github.com/Krasjet/k.iosevka/releases) page, but just in case
you want to build it yourself:

[npm](https://www.npmjs.com/),
[ttfautohint](http://www.freetype.org/ttfautohint/),
[otfcc](https://github.com/caryll/otfcc),
[AFDKO](https://adobe-type-tools.github.io/afdko/AFDKO-Overview.html) are
required to build this typeface. If you are using Arch Linux and
[`yay`](https://github.com/Jguer/yay), the dependencies can be installed on
AUR.

```bash
$ yay -S npm otfcc ttfautohint afdko
```

Then, use the makefile to take care of everything.

```bash
$ make setup
$ make build
```

The output is in the `out` directory.

## Nerd fonts patch

The `term` variant is intended to be used in the terminal, and it is sometimes
necessary to patch the font with [Nerd
fonts](https://github.com/ryanoasis/nerd-fonts) to add additional symbols for
various terminal applications.

[`fontforge`](https://fontforge.org) and [subversion](https://subversion.apache.org/)
are required to apply the patch. I'm using subversion here only because it is a pain to
download a single folder from GitHub. Follow the instruction in `Makefile` if
you want to use `git` instead. Otherwise, install the dependencies via
```bash
$ yay -S fontforge subversion
```
Then run the patcher by
```bash
$ make setup-nerd
$ make patch
```
The patched fonts can be found in the `patched` directory. They are internally referenced by the name `k.iosevka.term Nerd Font`.
