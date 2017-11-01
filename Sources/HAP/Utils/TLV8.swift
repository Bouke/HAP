import Foundation

typealias PairTagTLV8 = [PairTag: Data]

enum TLV8Error: Swift.Error {
    case UnknownKey(UInt8)
    case DecodeError
}

func decode<Key: Hashable>(_ data: Data) throws -> [Key: Data] where Key: RawRepresentable, Key.RawValue == UInt8 {
    var result = [Key: Data]()
    var index = data.startIndex
    while index < data.endIndex {
        guard let type = Key(rawValue: data[index]) else {
            throw TLV8Error.UnknownKey(data[index])
        }
        index = data.index(after: index)

        let length = Int(data[index])
        index = data.index(after: index)

        guard let endIndex = data.index(index, offsetBy: length, limitedBy: data.endIndex) else { throw TLV8Error.DecodeError }
        let value = data[index..<endIndex]

        if let append = result[type] {
            result[type] = append + Data(bytes: Array(value))
        } else {
            result[type] = Data(bytes: Array(value))
        }

        index = endIndex
    }
    return result
}

func encode<Key>(_ data: [Key: Data]) -> Data where Key: RawRepresentable, Key.RawValue == UInt8 {
    var result = Data()
    func append(type: UInt8, value: Data.SubSequence) {
        result.append(Data(bytes: [type, UInt8(value.count)] + value))
    }

    for (type, value) in data {
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

enum PairSetupStep: UInt8 {
    case waiting = 0, startRequest, startResponse, verifyRequest, verifyResponse, keyExchangeRequest, keyExchangeResponse
}

enum PairVerifyStep: UInt8 {
    case waiting = 0, startRequest, startResponse, finishRequest, finishResponse
}

enum PairTag: UInt8 {
    // Method to use for pairing. See Table 4-4 (page 60).
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
