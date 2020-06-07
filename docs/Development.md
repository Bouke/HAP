Development
===========

## Running tests

Certain tests involve crypto, which can be a bit slow in debug builds. Best to run the tests with a release build, like this:

```
swift test -c release -Xswiftc -enable-testing
```
