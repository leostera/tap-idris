# `TAP`
> 🍻 A simple TAP producer for Idris and an even simpler consumer

`TAP` is a terse, minimalistic, text-based protocol for reporting test
results. Read more at [www.testanything.org](https://testanything.org)

Note: this is just something I hacked together to produce consistent test
results for a small Lisp parser: [Libra](https://github.com/ostera/libra).

## Quick Start

Run `make` to build the library and the conusmer binary and install the library.

> Note: make sure to put the `draft` binary somewhere in your path if you want
> to use it!

## Library Usage

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

### Why `Lazy (IO Bool)`

I figured that some tests might want to perform some side-effects (reading a
fixture file sounds like the most likely scenario) and if I didn't include the
wrapper at this point we'd need to also provide an IO-aware version of `plan`.

Feel encouraged to challenge and teach me why this is the wrong approach.

## Binary Usage

The binary itself _reads_ TAP output, so you can pipe the output of your test
command into it:

```
ostera λ make test | draft
...
# ok 2
# not ok 1
```

It's extremely simple, but it gives me something to work with for the time being.

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

- [x] `# ok 4`
- [x] `# not ok 1`
- [ ] `# skipped 0`
- [ ] `# todo 0`
- [ ] `# summary 1/5 tests, 80.00% okay`
