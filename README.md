# mcpackutil
[![PyPI](https://img.shields.io/pypi/v/mcpackutil.svg)](https://pypi.python.org/pypi/mcpackutil)
[![PyPI](https://img.shields.io/pypi/pyversions/mcpackutil.svg)](https://pypi.python.org/pypi/mcpackutil)

[![PyPI](https://img.shields.io/pypi/dd/mcpackutil.svg)](https://pypi.python.org/pypi/mcpackutil)
[![PyPI](https://img.shields.io/pypi/dw/mcpackutil.svg)](https://pypi.python.org/pypi/mcpackutil)
[![PyPI](https://img.shields.io/pypi/dm/mcpackutil.svg)](https://pypi.python.org/pypi/mcpackutil)

A CLI application for working with Minecraft resource packs

## Installation
### Via PIP
If you have `pip` installed, you can run;
```
pip install mcpackutil
```
This will install both the library and CLI tool. The CLI tool can then be used via `mcpackutil`, given the directory it was installed to is in your `PATH`
### Via Just
If you want to build the library and/or CLI tool locally and have `just` installed, you can run
```
just build
```
To install both the library and CLI tool or;
```
just build-exe
```
To build just the executable or;
```
just build-lib
```
To build just the Python library as a wheel

## Usage
### CLI
To use the CLI tool, given it is on your `PATH`, you can call it from the terminal with `mcpackutil`, though this will do nothing by itself. You can pass `-h` or `--help` to show text similar to the following;
```
Usage: mcpackutil [OPTIONS] COMMAND [ARGS]...

Options:
  -v, --version
  -n, --name
  -a, --author
  -d, --debug
  -h, --help     Show this message and exit.

Commands:
  extract  Extract a resource pack from a local Minecraft version
  locate   Locate your .minecraft folder
  valid    Validate if a folder or .zip is a resource pack
  zip      Zip up a pack folder
```
Calling `mcpackutil extract` will also require additional arguments, or it will print out the following;
```
Usage: mcpackutil extract [OPTIONS] COMMAND [ARGS]...

  Extract a resource pack from a local Minecraft version

Options:
  -v, --version TEXT  1.16.5,1.17,1.17-pre4,21w20a,1.17.1-pre2,1.12.2,1.17.1-p
                      re1,1.17-rc1

  -o, --output PATH
  -i, --icons
  -h, --help          Show this message and exit.

Commands:
  asset    Extract icons, sound and lang files from a local Minecraft client
  version  Extract the assets of a local Minecraft version
```
Similarly, calling `mcpackutil extract asset` will print a similar message to the following;
```
Usage: mcpackutil extract asset [OPTIONS] COMMAND [ARGS]...

  Extract icons, sound and lang files from a local Minecraft client

Options:
  -h, --help  Show this message and exit.

Commands:
  minecraft  Extracts local core assets associated with Minecraft
  realms     Extracts local assets associated with Realms
```
However `mcpackutil extract version` will use the latest version of Minecraft by default (supplied at the `extract` portion) and require no arguments to function, though file paths can be given as a denylist

Calling `mcpackutil extract asset minecraft` will extract all options unless supplied with `-h` or `--help` for which it will instead print the following message;
```
Usage: mcpackutil extract asset minecraft [OPTIONS]

  Extracts local core assets associated with Minecraft

Options:
  -i, --icons
  -l, --lang
  -s, --sounds
  -h, --help    Show this message and exit.
```
Calling `mcpackutil extract asset realms` will extract all options unless given `-h` or `--help`, in that case it will print the following;
```
Usage: mcpackutil extract asset realms [OPTIONS]

  Extracts local assets associated with Realms

Options:
  -l, --lang
  -t, --textures
  -h, --help      Show this message and exit.
```