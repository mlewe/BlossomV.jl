# BlossomV.jl

[![Build Status](https://travis-ci.org/mlewe/BlossomV.jl.svg?branch=master)](https://travis-ci.org/mlewe/BlossomV.jl)

This package provides a julia wrapper to the Blossom V software package which
provides an implementation of a minimum cost perfect matching algorithm.

Blossom V is available under http://pub.ist.ac.at/~vnk/software.html

The algorithm is described in

    Blossom V: A new implementation of a minimum cost perfect matching algorithm.
    Vladimir Kolmogorov.
    In Mathematical Programming Computation (MPC), July 2009, 1(1):43-67.

The Wrapper provided in this package is very simplistic, a nicer interface will
be provided in future versions.  There are several things you can do that will
cause it to segfault -- often causing julia to segfault.


## Building
You can install the package with the usual `Pkg.add("BlossomV")`.
If something goes wrong you may need to delete `.julia/v0.5/BlossomV/julia/src/*`
or similar.

A common thing that goes wrong is not having current enough version of C++ and
its stdlibs. Currently the minimum requirements are a compiler supporting the
C++11 standard (e.g. gcc-4.6 on ubuntu 12.04, or newer, should be recent
enough).

## Usage
The main exported type is `Matching`. Here is its docstring:

```julia
"""
    type Matching{T<:Union{Int32, Float64}}
        ptr::Ptr{Void}
    end

A type containing a pointer to a BlossomV struct for perfect matching.
`T` is the type of the edge weights.

The following constructors are available:

    Matching(node_num)
    Matching(node_num, edge_num_max)
    Matching(T, node_num)
    Matching(T, node_num, edge_num_max)

If `T` is not given it will default to `Int32`.

After adding edges and weights with `add_edge(match, i, j, weight)`
use `solve(match)` to find an optimal matching and `get_match(match, i)`
to retrieve it.
"""
```

See `test/runtests.jl` for usage examples.
