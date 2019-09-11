Homekit Accessory Protocol, implemented in Swift
================================================

The goal of this package is to provide a complete implementation of the Homekit Accessory Protocol, enabling you to build your DIY accessories, and connect your non-HAP devices.

[![Build Status](https://travis-ci.org/Bouke/HAP.svg?branch=master)](https://travis-ci.org/Bouke/HAP)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=Bouke_HAP&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=Bouke_HAP)

## Features

* Persistent configuration across reboots.
* Homekit pairing by scanning QR code (shipped in iOS 11).
* Speakers and Remote Control accessories (shipped in iOS 12 / macOS Mojave).
* Television accessories (shipped in iOS 12.2 / macOS 10.14.3).
* Extensibility through custom services and characteristics.
* Runs on Linux / Raspbian (Raspberry Pi).

## First run

### MacOS

Install libsodium (used for Curve25519 and Ed25519):

    brew install libsodium

And then build and run the project itself:

    swift run hap-server -c release

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

    swift run hap-server -c release

## Raspberry Pi (Raspbian Stretch)

There are currently no official binaries from swift.org targetting ARM / Raspbian, however there's an active community working on Swift on ARM. You can [install binaries from their repository][1]:

    curl -s https://packagecloud.io/install/repositories/swift-arm/release/script.deb.sh | sudo bash
    sudo apt install swift5

## Usage

Modify ``Sources/hap-server/main.swift`` to include your own accessories, or import the _HAP_ library into your own project.

On Mac OS, you can debug using XCode by running the command ``swift package generate-xcodeproj`` and the opening the resulting ``HAP.xcodeproj`` project. Select and run the ``hap-server`` target.

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

Certain tests involve crypto, which can be a bit slow in debug builds. Best to run the tests with a release build, like this:

    swift test -c release -Xswiftc -enable-testing

### Implementation notes

Currently ``GenericCharacteristic<T>`` is used, to allow for user-defined value types. As Swift requires homegenous arrays, a protocol ``AnyCharacteristic`` is introduced. I don't like the resulting implementation as the generics result in a cascade of workarounds (boxing + ``ObjectIdentifier()``).

## Credits

This library was written by [Bouke Haarsma](https://twitter.com/BoukeHaarsma)
and [contributors][0].

[0]: https://github.com/Bouke/HAP/graphs/contributors
[1]: https://swift-arm.com/install-swift/
