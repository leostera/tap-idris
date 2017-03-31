# `TAP`
> 🍻 A simple TAP producer for Idris

`TAP` is a concise, minimalistic, text-based protocol for reporting test
results. Read more at [www.testanything.org](https://testanything.org)

Note: this is just something I hacked together to produce consistent test
results for a small Lisp parser: [Libra](https://github.com/ostera/libra).

## Quick Start

Run `make` and get it up!

## Usage

The interface is fairly straightforward, a single function for planning:

```
plan : (suite : String) -> Vect n (IO Bool) -> IO ()
```

You can use it like this:

```
module Your.Module.Tests

import TAP

myTestSuite : IO ()
myTestSuite = plan "Some description" [
  testCase1,
  testCase2,
  testCase3
]
```

And you can add `Your.Module.Tests.myTestSuite` to the list of tests in your
`*.ipkg` file.

## Specification

This is a list of things I'd like the TAP producer to eventually produce the
following parts of a typical TAP output:

- [X] `TAP version 13`
- [X] `1..N`
- [X] `ok 1`
- [X] `not ok 2`
- [ ] `ok 3 with a test case description`
- [ ] `ok 4 # TODO with an explanation`
- [ ] `ok 5 # SKIP with an explanaation`
