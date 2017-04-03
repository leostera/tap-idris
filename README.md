# `TAP`
> 🍻 A simple TAP producer for Idris

`TAP` is a terse, minimalistic, text-based protocol for reporting test
results. Read more at [www.testanything.org](https://testanything.org)

Note: this is just something I hacked together to produce consistent test
results for a small Lisp parser: [Libra](https://github.com/ostera/libra).

## Quick Start

Run `make` to build and install.

## Usage

The interface is fairly straightforward, a single function for planning:

```idris
plan : (suite : String) -> Vect n (Lazy (IO Bool)) -> IO ()
```

And you can use it like this:

```idris
module Your.Module.Tests

import TAP

testCase : Lazy (IO Bool)
testCase = case compare (1+1) 2 of
              EQ => pure True
              LT => pure False
              GT => pure False

myTestSuite : IO ()
myTestSuite = plan "Some description" [
  Delay (testCase),
]
```

So it's _almost_ compliant with the interface of current Idris tests:

1. add `Your.Module.Tests.myTestSuite` to the list of tests in your `*.ipkg` file and
2. run `idris --testpkg *.ipkg`

And you should see an output like:

```
ostera λ make test
TAP version 13
1..1
ok 1
```

## Why `Lazy (IO Bool)`

I figured that some tests might want to perform some side-effects (reading a
fixture file sounds like the most likely scenario) and if I didn't include the
wrapper at this point we'd need to also provide an IO-aware version of `plan`.

Feel encouraged to challenge and teach me why this is the wrong approach.

## Specification

This is a list of things I'd like the TAP producer to eventually produce the
following parts of a typical TAP output:

- [X] `TAP version 13`
- [X] `# Description`
- [X] `1..N`
- [X] `ok 1`
- [X] `not ok 2`
- [ ] `ok 3 with a test case description`
- [ ] `ok 4 # TODO with an explanation`
- [ ] `ok 5 # SKIP with an explanaation`

But it'd also be nice to have a consumer of the output to produce more
interesting reports, such as:

- [ ] `OK tests 4`
- [ ] `FAILED tests 1`
- [ ] `SKIPPED tests 0`
- [ ] `TODO tests 0`
- [ ] `Failed 1/5 tests, 80.00% okay`
