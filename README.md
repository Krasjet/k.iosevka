# k.iosevka

A custom build of [Iosevka](https://typeof.net/Iosevka/) for personal use. A preview of the typeface can be found at [Julia as a CLI calculator](https://krasjet.com/rnd.wlk/julia/).

![preview](./preview.png)
![preview-italic](./preview-italic.png)

## Build

[npm](https://www.npmjs.com/),
[ttfautohint](http://www.freetype.org/ttfautohint/),
[otfcc](https://github.com/caryll/otfcc),
[AFDKO](https://adobe-type-tools.github.io/afdko/AFDKO-Overview.html) are
required to build this typeface. If you are using Arch Linux, they can be
installed on AUR.

```bash
$ yay -S npm otfcc ttfautohint afdko
```

Then, use the makefile to take care of everything.

```bash
$ make setup
$ make build
```

The output is in the `out` directory.

## Nerd font patch

The `term` variant is intended to be used in the terminal, and it is sometimes necessary
