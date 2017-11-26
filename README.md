[![Build Status](https://travis-ci.org/gap-packages/anatph.svg?branch=master)](https://travis-ci.org/gap-packages/anatph)
[![Code Coverage](https://codecov.io/github/gap-packages/anatph/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/anatph)

# The GAP 4 package `anatph'

This package contains a proof-of-concept implementation of the "New approach to proving hyperbolicity" algorithm.

# /!\ WARNING /!\

This is work-in-progress. There are probably many bugs, and places in which I did not understood
the algorithm correctly yet. Do not yet trust output of the provided code.

If you do play with it and find problems, let me know, file an issue, or send me an email, and I will
be happy to discuss.

# Installation

This package should work on any recent [GAP](http://www.gap-system.org) release newer than 4.8.3.
It depends on the package [digraphs](https://gap-packages.github.io/Digraphs), which itself depends
on [io](https://gap-packages.github.io/io) and [orb](https://gap-packages.github.io/orb).i

Currently, there is also a dependency on the package [profiling](https://gap-packages.github.io/profiling).

All these packages are distributed with GAP but need compilation of GAP kernel extensions.

At the moment you're stuck with the current state of the git repository. To get an initial version,
it is best to clone the repository, into your `pkg` folder. To do this, change into your GAP
installation's pkg folder and execute the following commands:

```sh
# cd gap4r8/pkg
# git clone https://github.com/gap-packages/anatph
```
You can then at any point update to the latest state of code by changing into the `anatph` directory
and executing
```sh
# git pull
```
Alternatively you can download a `zip` archive of the current state of the `anatph` repository available
at [this link](https://github.com/gap-packages/anatph/archive/master.zip). Unzip this file into your GAP
`pkg` folder. Keep in mind that you cannot update code or produce patches from it this way.

Getting Started
===============

```gap
gap> LoadPackage("anatph");;
...
gap> pg := PregroupOfFreeGroup(2);
<pregroup with 5 elements in table rep>
gap> pr := RandomPregroupPresentation(pg, 10, 50);
<pregroup presentation with 4 generators and 10 relators>
gap> RSymTest(pr, 1/6);
true
```

```gap
gap> pr := TriSH(7,13);
<pregroup presentation with 3 generators and 2 relators>
gap> RSymTest(pr, 1/6);
[ fail, [ [ 1, 0, 0, 0 ], [ 1, 2, 1, 0. ], [ 1, 4, 1, 0.166667 ], [ 3, 1, 1, 0.0833333 ], [ 3, 3, 1, 0.25 ], [ 1, 6, 2, 0.333333 ], [ 3, 5, 2, 0.416667 ], 
      [ 1, 8, 3, 0.5 ], [ 2, 6, 3, 0.25 ], [ 2, 8, 4, 0.416667 ], [ 3, 7, 3, 0.583333 ], [ 2, 4, 2, 0.0833333 ], [ 1, 10, 4, 0.666667 ], [ 2, 10, 4, 0.416667 ], [ 3, 9, 4, 0.75 ], 
      [ 1, 12, 4, 0.666667 ], [ 2, 12, 4, 0.416667 ], [ 3, 11, 4, 0.75 ] ], [ 1, 10, 4, 0.666667 ] ]
```

## Documentation

Full information and documentation can be found in the manual, available
as PDF `doc/manual.pdf` or as HTML `htm/chapters.htm`, or on the package
homepage at

  <http://gap-packages.github.io/anatph/>


## Bug reports and feature requests

Please submit bug reports and feature requests via our GitHub issue tracker:

  <https://github.com/gap-packages/anatph/issues>


# License

anatph is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

For details see the files COPYRIGHT.md and LICENSE.

