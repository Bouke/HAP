Getting Started
===============

## Installing dependencies

### macOS
On macOS this package depends on libsodium to provide certain crypto algorithms. Install it using homebrew:
```
brew install libsodium
```

### Linux
On Debian based Linux distributions you need a few packages. Install them using apt:
```
sudo apt install openssl libssl-dev libsodium-dev libcurl4-openssl-dev libavahi-compat-libdnssd-dev
```

If your package manager doesn't provide libsodium 1.0.9 or higher, install it from source:
```
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.12.tar.gz
tar xzf libsodium-1.0.12.tar.gz
cd libsodium-1.0.12
./configure
make && make check
sudo make install
sudo ldconfig
```

### Linux ARM / Raspberry Pi (Raspbian Stretch)
There are currently no official binaries from swift.org targetting ARM / Raspbian, however there's an active community working on Swift on ARM. You can [install binaries from their repository][1]:

```
curl -s https://packagecloud.io/install/repositories/swift-arm/release/script.deb.sh | sudo bash
sudo apt install swift5
```

## First run
Now that you have all the dependencies installed, you should be able to build and run the demo. For optimal performance, use a release build:
```
swift run -c release hap-demo
```

[1]: https://github.com/futurejones/swift-arm64
