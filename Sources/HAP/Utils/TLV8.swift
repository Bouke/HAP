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

func encode<Key: Hashable>(_ data: [Key: Data]) -> Data where Key: RawRepresentable, Key.RawValue == UInt8 {
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
    case pairingMethod = 0, username, salt, publicKey, proof, encryptedData, sequence, errorCode
    case signature = 0x0a

    // un-used
    case mfiCertificate = 0x09
    case mfiSignature = 0x0b // unsure, hc re-uses 0x0a -- /pairings received 0x0b one time, could it be 0x0b?
}

enum PairMethod: UInt8 {
    case `default` = 0, mfi, add = 3, delete
}

enum PairStep: UInt8 {
    case request = 0x01
    case response = 0x02
}
