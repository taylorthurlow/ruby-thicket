[![Gem Version](https://badge.fury.io/rb/thicket.svg)](https://badge.fury.io/rb/thicket)
[![Build Status](https://travis-ci.com/taylorthurlow/thicket.svg?branch=develop)](https://travis-ci.com/taylorthurlow/thicket)
[![Code Climate Maintainability](https://img.shields.io/codeclimate/maintainability/taylorthurlow/thicket.svg)](https://codeclimate.com/github/taylorthurlow/thicket)
[![Code Climate Test Coverage](https://img.shields.io/codeclimate/coverage/taylorthurlow/thicket.svg)](https://codeclimate.com/github/taylorthurlow/thicket)

`thicket` is an opinionated wrapper for `git log`.

### Getting started

#### Prerequisites

- Ruby >= 2.3

#### Installing

To install the latest 'stable' release of `thicket`:

```bash
gem install thicket
```

For help, run `thicket -h`:

```
$ thicket -h
Usage: thicket [options] <command>
    -v, --version                    Print the version number
    -h, --help                       Prints this help
    -d, --directory DIRECTORY        Path to the project directory
    -a, --all                        Displays all branches on all remotes.
    -p, --color-prefixes             Adds coloring to commit message prefixes.
        --git-binary BINARY          Path to a git executable
```

### Contributing

Please open an issue regarding any changes you wish to make before starting to work on anything. I am always open to providing assistance, so if you need to ask any questions please don't hesitate to do so, whether it be how to approach solving a problem or questions regarding how I might prefer something be implemented.

This project uses [Rufo](https://github.com/ruby-formatter/rufo) to format its source code, and pull requests will not be accepted unless all code has been run through it.

#### Running tests

I use `rspec` for testing. If submitting a pull request, always include tests if possible. Please adhere to the testing style in the pre-existing tests, particularly when testing a new component.
