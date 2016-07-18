//
//  HAP.swift
//  HAP
//
//  Created by Bouke Haarsma on 20-06-16.
//
//

import Foundation

//public class Accessory {
//    public let name: String
//    public let identifier: String
//    public let version: String
//    public let state: String
//    public let discoverable: Bool
//    public let mfiCompliant: Bool
//    public let category: Int
//}

typealias TLV8 = [UInt8: Data]

enum TLV8Error: ErrorProtocol {
    case DecodeError
}

func decode(_ data: Data) throws -> TLV8 {
    var result = [UInt8: Data]()
    var index = data.startIndex
    while index < data.endIndex {
        let type = data[index]
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

func encode(_ data: TLV8) -> Data {
    var result = Data()
    func append(type: UInt8, value: Data.SubSequence) {
        result.append(Data(bytes: [type, UInt8(value.count)] + value))
    }

    for (type, value) in data {
        var index = value.startIndex
        repeat {
            if let endIndex = value.index(index, offsetBy: 255, limitedBy: value.endIndex) {
                append(type: type, value: value[index..<endIndex])
                index = endIndex
            } else {
                append(type: type, value: value[index..<value.endIndex])
                index = value.endIndex
            }
        } while index < value.endIndex
    }
    return result
}

enum PairSetupStep: UInt8 {
    case waiting = 0, startRequest, startResponse, verifyRequest, verifyResponse, keyExchangeRequest, keyExchangeResponse
}

enum VerifyStep: UInt8 {
    case waiting = 0, startRequest, startResponse, finishRequest, finishResponse
}

enum Tag: UInt8 {
    case pairingMethod = 0, username, salt, publicKey, proof, encryptedData, sequence, errorCode
    case signature = 0x0a
//    case mfiCertificate = 0x09, mfiSignature = 0x0a // todo: cannot re-use the raw value of `signature`
}

enum PairMethod: UInt8 {
    case `default` = 0, mfi, add = 3, delete
}
