# Contributing to Salsa

**First:** if you're unsure or afraid of *anything*, just ask or submit the issue
or pull request anyways. You won't be yelled at for giving your best effort.
The worst that can happen is that you'll be politely asked to change something.
We appreciate any sort of contributions, and don't want a wall of rules to get
in the way of that.

However, for those individuals who want a bit more guidance on the best way to
contribute to the project, read on. This document will cover what we're looking
for. By addressing all the points we're looking for, it raises the chances we
can quickly merge or address your contributions.

## Issues

### Reporting an Issue

- Make sure you test against the latest released version. It is possible we already fixed the bug you're experiencing.
- Provide a reproducible test case. If a contributor can't reproduce an issue, then it dramatically lowers the chances it'll get fixed. And in some cases, the issue will eventually be closed.
- Respond promptly to any questions made by the Packer team to your issue. Stale issues will be closed.

## Setting up Go to work on Packer

If you have never worked with Go before, you will have to complete the following steps in order to be able to compile and test Packer.

1. Install Go. On a Mac, you can `brew install go`.
2. Set and export the `GOPATH` environment variable. For example, you can add
   `export GOPATH=$HOME/Documents/golang` to your `.bash_profile`.
3. Download the Salsa source by running `go get github.com/henrikhodne/salsa`.
   This will download the Salsa source to
   $GOPATH/src/github.com/henrikhodne/salsa.
4. Make your changes to the Salsa source. You can run make from the main source
   directory to recompile all the binaries. Any compilation errors will be
   shown when the binaries are rebuilding.
5. Test your changes.
6. If everything works well and the tests pass, run `go fmt` on your code
   before submitting a pull request.
