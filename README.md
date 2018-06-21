[![Build Status](https://travis-ci.org/gap-packages/walrus.svg?branch=master)](https://travis-ci.org/gap-packages/walrus)
[![Code Coverage](https://codecov.io/github/gap-packages/walrus/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/walrus)
[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/gap-packages/walrus/binder-test?filepath=Polynomial-time%20proofs%20that%20groups%20are%20hyperbolic.ipynb)


# `walrus` - Computational Methods for Finitely Generated Monoids and Groups

The main feature of this package currently is an implementation of methods for 
proving hyperbolicity of finitely presented groups in polynomial time based on
an algorithm due to Richard Parker, described in the paper "Polynomial-time
proofs that groups are hyperbolic".

For lightweight experimentation with `walrus` you can use the 
[MyBinder demo](https://mybinder.org/v2/gh/gap-packages/walrus/binder-test?filepath=Polynomial-time%20proofs%20that%20groups%20are%20hyperbolic.ipynb) in your browser.

Future work on this package will include a more sophisticated implementation of
the `RSym` procedure, integration of Knuth-Bendix methods from `kbmag` for
hyperbolicity testing, and the word-problem solver as described in "Polynomial-time
proofs that groups are hyperbolic".

# Installation

This package works with [GAP](http://www.gap-system.org) version `4.9.1` or
later, and does not require compilation of a kernel module.

Along with packages that are distributed with GAP (`GAPDoc`, `io`, `digraphs`,
and `kbmag`), it depends on the as-yet not deposited package
[datastructures](https://github.com/gap-packages/datastructures), which needs
to be installed and compiled manually.

## Documentation

Full information and documentation can be found in the manual, available
as PDF `doc/manual.pdf` or as HTML `htm/chapters.htm`, or on the package
homepage at

  <http://gap-packages.github.io/walrus/>


## Bug reports and feature requests

Please submit bug reports and feature requests via our GitHub issue tracker:

  <https://github.com/gap-packages/walrus/issues>


# License

walrus is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

For details see the files COPYRIGHT.md and LICENSE.

# Why `walrus`?

The Walrus is Captain Flint's ship in Robert Louis Stevenson's *Treasure
Island*. Sailing ships come with a lot of ropes, which, when you think about
it, are glorified strings.
