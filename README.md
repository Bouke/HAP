Homekit Accessory Protocol, implemented in Swift
================================================

The goal of this package is to provide a complete implementation of the Homekit Accessory Protocol, to build your DIY accessories, or provide a bridge for non-HAP devices.

[![Build Status](https://travis-ci.org/Bouke/HAP.svg?branch=master)](https://travis-ci.org/Bouke/HAP)

## Implementation notes

Currently ``GenericCharacteristic<T>`` is used, to allow for user-defined value types. As Swift requires homegenous arrays, a protocol ``AnyCharacteristic`` is introduced. I don't like the resulting implementation as the generics result in a cascade of workarounds (boxing + ``ObjectIdentifier()``).

## How to build

### MacOS

Install libsodium (used for Curve25519 and Ed25519):

    brew install libsodium
    brew link libsodium

And then build the project itself:

    swift build

### Linux

Install dependencies:

    sudo apt-get install openssl libssl-dev libsodium-dev libcurl4-openssl-dev

Make sure you have libsodium 1.0.9 or above. Ubuntu 16.10 or later suffices.
Otherwise you have to compile and install libsodium from source;

    wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.12.tar.gz
    tar xzf libsodium-1.0.12.tar.gz
    cd libsodium-1.0.12
    ./configure
    make && make check
    sudo make install
    sudo ldconfig

And then build the project itself:

    swift build

## Usage

Run ``swift build`` to compile and ``.build/debug/hap-server`` to run. Modify ``Sources/hap-server/main.swift`` to include your own accessories.

On Mac OS, you can debug using XCode by running the command ``swift package generate-xcodeproj`` and the opening the resulting ``HAP.xcodeproj`` project. Select the ``hap-server`` target to execute.

## Linux

Currently Linux is not supported due to use of NetService, which is not (yet) available in Swift-Foundation. I've been working on implementing NetService, but the implementation isn't complete yet. Patches welcome.

CommonCrypto has been replaced with the portable BlueCryptor; it uses CommonCrypto on Apple platforms and OpenSSL on Linux. 

## Credits

This library was written by [Bouke Haarsma](https://twitter.com/BoukeHaarsma).
