Homekit Accessory Protocol, implemented in Swift
================================================

The goal of this package is to provide a complete implementation of the Homekit Accessory Protocol, to build your DIY accessories, or provide a bridge for non-HAP devices.

[![Build Status](https://travis-ci.org/Bouke/HAP.svg?branch=master)](https://travis-ci.org/Bouke/HAP)

## Features

* Persistent configuration
* Pair by scanning QR code (WWDC 2017)
* Write custom services and characteristics
* Linux / Raspbian (Raspberry Pi) support

## How to build

### MacOS

Install libsodium (used for Curve25519 and Ed25519):

    brew install libsodium

And then build the project itself:

    swift build -c release

### Linux

Install dependencies:

    sudo apt install openssl libssl-dev libsodium-dev libcurl4-openssl-dev libavahi-compat-libdnssd-dev

Make sure you have libsodium 1.0.9 or above. Ubuntu 16.10 or later suffices. Otherwise you have to compile and install libsodium from source:

    wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.12.tar.gz
    tar xzf libsodium-1.0.12.tar.gz
    cd libsodium-1.0.12
    ./configure
    make && make check
    sudo make install
    sudo ldconfig

And then build the project itself:

    swift build -c release

## Raspberry Pi (Raspbian Stretch)

There are currently no official binaries from swift.org targetting ARM / Raspbian, however there's an active community working on Swift on ARM. You can [install binaries from their repository][1]:

    curl -s https://packagecloud.io/install/repositories/swift-arm/release/script.deb.sh | sudo bash
    sudo apt install swift4

## Usage

Run ``swift build`` to compile and ``.build/debug/hap-server`` to run. Modify ``Sources/hap-server/main.swift`` to include your own accessories.

On Mac OS, you can debug using XCode by running the command ``swift package generate-xcodeproj`` and the opening the resulting ``HAP.xcodeproj`` project. Select the ``hap-server`` target to execute.

## Extensibility

The following code snippet how you would model a fictious accessory
representing a mobile power bank.

```swift
class PowerBankAccessory: Accessory {
    let service = PowerBankService()
    init(info: Service.Info) {
        super.init(info: info, type: .outlet, services: [service])
    }
}
class PowerBankService: Service {
    public let on = GenericCharacteristic<Bool>(
        type: .on,
        value: false)
    public let inUse = GenericCharacteristic<Bool>(
        type: .outletInUse,
        value: true,
        permissions: [.read, .events])
    public let batteryLevel = GenericCharacteristic<Double>(
        type: .batteryLevel,
        value: 100,
        permissions: [.read, .events])

    init() {
        super.init(type: .outlet, characteristics: [
            AnyCharacteristic(on),
            AnyCharacteristic(inUse),
            AnyCharacteristic(batteryLevel)
        ])
    }
}
```

## Object-Oriented Design

A high-level overview of the objects involved are shown in the diagram below.
The terminology of HAP (Device, Accessory, Service, Characteristic) is
followed for ease of understanding.

                          +------------+
                          | NetService |
                          +------------+
                                 |
                                 | delegate
                                 v
       +--------+ 1     0…1 +--------+ *   * +---------------------+
       | Device |-----------| Server |-------| Controller (iPhone) |
       +--------+           +--------+       +---------------------+
            | 1                           * /
            | *                           /
      +-----------+                     /
      | Accessory |                   /
      +-----------+                 /
            | 1                   / > read, events
            | *                 / < write, subscribe
       +---------+            /
       | Service |          /
       +---------+        /
            | 1         /
            | *     * /
    +----------------+
    | Characteristic |
    +----------------+

## Development

### Running tests

Certain tests involve crypto, which can be a bit slow in debug builds. Best to
run the tests with a release build, like this:

    swift test -c release -Xswiftc -enable-testing

### Implementation notes

Currently ``GenericCharacteristic<T>`` is used, to allow for user-defined value types. As Swift requires homegenous arrays, a protocol ``AnyCharacteristic`` is introduced. I don't like the resulting implementation as the generics result in a cascade of workarounds (boxing + ``ObjectIdentifier()``).

## Credits

This library was written by [Bouke Haarsma](https://twitter.com/BoukeHaarsma)
and [contributors][0].

[0]: https://github.com/Bouke/HAP/graphs/contributors
[1]: https://swift-arm.com/install-swift/
