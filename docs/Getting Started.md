Getting Started
===============

## Installing dependencies

### macOS
No dependencies needed, besides the packages SwiftPM will download.

### Linux
On Debian based Linux distributions you need a few packages. Install them using apt:
```
sudo apt install openssl libssl-dev libcurl4-openssl-dev libavahi-compat-libdnssd-dev
```

#### Linux ARM / Raspberry Pi (Raspbian Stretch)
There are currently no official binaries from swift.org targetting ARM / Raspbian, however there's an active community working on Swift on ARM. You can [install binaries from their repository][1]:

```
curl -s https://packagecloud.io/install/repositories/swift-arm/release/script.deb.sh | sudo bash
sudo apt install swiftlang
```

## First run
Now that you have all the dependencies installed, you should be able to build and run the demo. For optimal performance, use a release build:
```
swift run -c release hap-demo
```

[1]: https://github.com/futurejones/swift-arm64
