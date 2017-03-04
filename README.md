Homekit Accessory Protocol, implemented in Swift
================================================

The goal of this package is to provide a complete implementation of the Homekit Accessory Protocol, to build your DIY accessories, or provide a bridge for non-HAP devices.

## Implementation notes

Currently ``GenericCharacteristic<T>`` is used, to allow for user-defined value types. As Swift requires homegenous arrays, a protocol ``AnyCharacteristic`` is introduced. I don't like the resulting implementation as the generics result in a cascade of workarounds (boxing + ``ObjectIdentifier()``).

## Status

* [x] Setup
* [x] Pairing
* [x] Updating values
* [x] Notifications
* [x] Split ``hap-server`` into executable and library
* [x] Accessory identify callback
* [½] Include all Accessories, Services and Characteristics
* [ ] Drop OpenSSL? Currently only used for Bignum (SRP)
* [ ] Overall cleanup
* [ ] Documentation
* [ ] Tests
* [ ] Verify authentication in /characteristic and /accessories
* [ ] Validate characteristic's permissions before setting new value
* [ ] Callbacks for when characteristic is subscribed to (only update when needed)
* [ ] Characteristic's value should only be nillable for write-only values

## How to build (as of Xcode 8 beta 6)

Install libsodium (used for Curve25519 and Ed25519):

    brew install libsodium
    brew link libsodium

Install openssl (used for bignum) and symlink the pkg-config files so SwiftPM can discover the correct compiler flags:

    brew install openssl
    ln -s /usr/local/opt/openssl/lib/pkgconfig/*.pc /usr/local/lib/pkgconfig

And then build the project itself:

    swift build

## Usage

Run ``swift build`` to compile and ``.build/debug/hap-server`` to run. Modify ``Sources/hap-server/main.swift`` to include your own accessories.

## Linux

Currently Linux is not supported due to use of NetService, which is not (yet) available in Swift-Foundation. Also there is a dependency on CommonCrypto, an Apple specific library to handle crypto stuff. Patches welcome.

## Credits

This library was written by [Bouke Haarsma](https://twitter.com/BoukeHaarsma).
