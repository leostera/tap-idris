# `TAP`
> 🍻 A simple TAP runner for Idris

`TAP` is a concise, minimalistic, text-based protocol for reporting test
results. Read more at [www.testanything.org](www.testanything.org)

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
