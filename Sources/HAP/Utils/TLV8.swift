import Foundation

typealias PairTagTLV8Tuple = (PairTag, Data)
typealias PairTagTLV8 = [PairTagTLV8Tuple]

extension Array where Element == PairTagTLV8Tuple {
    subscript(index: PairTag) -> Data? {
        return self.first(where: { $0.0 == index })?.1
    }

    var pairStep: PairStep? {
        return self
            .first(where: { $0.0 == PairTag.state })?.1
            .first
            .flatMap({ PairStep(rawValue: $0) })
    }

    var pairSetupStep: PairSetupStep? {
        return self
            .first(where: { $0.0 == PairTag.state })?.1
            .first
            .flatMap({ PairSetupStep(rawValue: $0) })
    }

    var error: PairError? {
        return self
            .first(where: { $0.0 == PairTag.error })?.1
            .first
            .flatMap({ PairError(rawValue: $0) })
    }

    static func == (lhs: [PairTagTLV8Tuple], rhs: [PairTagTLV8Tuple]) -> Bool {
        return lhs.elementsEqual(rhs, by: ==)
    }
}

// Requires Swift 4.1 -- conditional conformance.
//extension Array: ExpressibleByDictionaryLiteral where Element == PairTagTLV8Tuple {
//}
//extension Array: Equatable where Element == PairTagTLV8Tuple {
//}

enum TLV8Error: Swift.Error {
    case unknownKey(UInt8)
    case decodeError
}

func decode<Key>(_ data: Data) throws -> [(Key, Data)] where Key: RawRepresentable, Key.RawValue == UInt8 {
    var result = [(Key, Data)]()
    var index = data.startIndex
    var currentType: Key?
    var currentValue: Data?

    while index < data.endIndex {
        guard let type = Key(rawValue: data[index]) else {
            throw TLV8Error.unknownKey(data[index])
        }
        index = data.index(after: index)

        let length = Int(data[index])
        index = data.index(after: index)

        guard let endIndex = data.index(index, offsetBy: length, limitedBy: data.endIndex) else {
            throw TLV8Error.decodeError
        }
        let value = data[index..<endIndex]

        if currentType == nil || type != currentType! {
            if let currentType = currentType, let currentValue = currentValue {
                result.append((currentType, currentValue))
            }
            currentType = type
            currentValue = Data(bytes: Array(value))
        } else {
            currentValue! += Data(bytes: Array(value))
        }

        index = endIndex
    }
    if let currentType = currentType, let currentValue = currentValue {
        result.append((currentType, currentValue))
    }
    return result
}

func encode<Key>(_ array: [(Key, Data)]) -> Data where Key: RawRepresentable, Key.RawValue == UInt8 {
    var result = Data()
    func append(type: UInt8, value: Data.SubSequence) {
        result.append(Data(bytes: [type, UInt8(value.count)] + value))
    }

    for (type, value) in array {
        var index = value.startIndex
        repeat {
            if let endIndex = value.index(index, offsetBy: 255, limitedBy: value.endIndex) {
                append(type: type.rawValue, value: value[index..<endIndex])
                index = endIndex
            } else {
                append(type: type.rawValue, value: value[index..<value.endIndex])
                index = value.endIndex
            }
        } while index < value.endIndex
    }
    return result
}

// Pair Setup State
enum PairSetupStep: UInt8 {
    case waiting = 0

    // M1: iOS Device -> Accessory -- `SRP Start Request'
    case startRequest = 1

    // M2: Accessory -> iOS Device -- `SRP Start Response'
    case startResponse = 2

    // M3: iOS Device -> Accessory -- `SRP Verify Request'
    case verifyRequest = 3

    // M4: Accessory -> iOS Device -- `SRP Verify Response'
    case verifyResponse = 4

    // M5: iOS Device -> Accessory -- `Exchange Request'
    case keyExchangeRequest = 5

    // M6: Accessory -> iOS Device -- `Exchange Response'
    case keyExchangeResponse = 6
}

// Pair Verification State
enum PairVerifyStep: UInt8 {
    case waiting = 0

    // M1: iOS Device -> Accessory -- `Verify Start Request'
    case startRequest = 1

    // M2: Accessory -> iOS Device -- `Verify Start Response'
    case startResponse = 2

    // M3: iOS Device -> Accessory -- `Verify Finish Request'
    case finishRequest = 3

    // M4: Accessory -> iOS Device -- `Verify Finish Response'
    case finishResponse = 4
}

enum PairTag: UInt8 {
    // TLV Types. See Table 4-6 (page 61).
    case pairingMethod = 0x00

    // Identifier for authentication. (UTF-8)
    case identifier = 0x01

    // 16+ bytes of random salt.
    case salt = 0x02

    // Curve25519, SRP public key, or signed Ed25519 key.
    case publicKey = 0x03

    // Ed25519 or SRP proof.
    case proof = 0x04

    // Encrypted data with auth tag at end.
    case encryptedData = 0x05

    // State of the pairing process. 1=M1, 2=M2, etc.
    case state = 0x06

    // Error code. Must only be present if error code is not 0.
    case error = 0x07

    // Seconds to delay until retrying a setup code.
    case retryDelay = 0x08

    // X.509 Certificate.
    case certificate = 0x09

    // Ed25519
    case signature = 0x0a

    // Bit value describing permissions of the controller being added.
    // None (0x00) : Regular user
    // Bit 1 (0x01) : Admin that is able to add and remove pairings against
    // the accessory.
    case permissions = 0x0b

    // Non-last fragment of data. If length is 0, it's an ACK.
    case fragmentData = 0x0c

    // Last fragment of data.
    case fragmentLast = 0x0d

    // Zero-length TLV that separates different TLVs in a list.
    case separator = 0xff
}

enum PairingMethod: UInt8 {
    // Method to use for pairing. See Table 4-4 (page 60).
    case `default` = 0 // TODO: according to specs, 0 is 'reserved'
    case pairSetup = 1
    case pairVerify = 2
    case addPairing = 3
    case removePairing = 4
    case listPairings = 5
}

enum PairStep: UInt8 {
    case request = 0x01
    case response = 0x02
}

// Error Codes. See Table 4-5 (page 60).
enum PairError: UInt8 {
    // Generic error to handle unexpected errors.
    case unknown = 0x01

    // Setup code or signature verification failed.
    case authenticationFailed = 0x02

    // Client must look at the retry delay TLV item and wait that many seconds
    // before retrying.
    case backoff = 0x03

    // Server cannot accept any more pairings.
    case maxPeers = 0x04

    // Server reached its maximum number of authentication attempts.
    case maxTries = 0x05

    // Server pairing method is unavailable.
    case unavailable = 0x06

    // Server is busy and cannot accept a pairing request at this time.
    case busy = 0x07
}

import Foundation
import HTTP

extension HTTPResponse {
    init(tags: PairTagTLV8) {
        self.init(status: .ok,
                  headers: HTTPHeaders([("Content-Type", "application/pairing+tlv8")]),
                  body: encode(tags))
    }
}
