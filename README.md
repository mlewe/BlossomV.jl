# BlossomV.jl

[![Build Status](https://travis-ci.org/mlewe/BlossomV.jl.svg?branch=master)](https://travis-ci.org/mlewe/BlossomV.jl)

This package provides a julia wrapper to the Blossom V software package which provides an implementation of a minimum cost perfect matching algorithm.

Blossom V is available under http://pub.ist.ac.at/~vnk/software.html

The algorithm is described in

    Blossom V: A new implementation of a minimum cost perfect matching algorithm.
    Vladimir Kolmogorov.
    In Mathematical Programming Computation (MPC), July 2009, 1(1):43-67.

The Wrapper provided in this package is very simplistic, a nicer interface will be provided in future versions.
There are several things you can do that will cause it to segfault -- often causing julia to segfault.


## Building
You can install the package with the usual `Pkg.add("BlossomV")`.
If something goes wrong you may need to delete `.julia/v0.5/BlossomV/julia/src/*` or similar.

A common thing that goes wrong is not having current enough version of C++ and its stdlibs.

A resulution for this for  Ubuntu 14.04 (for example) looks like (Disclaimer: it is on you and your sys-admin to determine how to manage system packages. This is just 1 way.):

```
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install gcc-6 g++-6

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 30
sudo update-alternatives --set gcc /usr/bin/gcc-6					  
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 30 
sudo update-alternatives --set g++ /usr/bin/g++-6
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
sudo update-alternatives --set c++ /usr/bin/g++

c++ --version #this should output a version saying you are using version 6
```



