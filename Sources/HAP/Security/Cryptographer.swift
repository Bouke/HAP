// swiftlint:disable identifier_name
import Foundation
import Logging
import NIO

fileprivate let logger: Logger = {
    var _logger = Logger(label: "hap.encryption")
    _logger.logLevel = .warning
    return _logger
}()

// 5.5.2 Session Security
// (...)
// Each HTTP message is split into frames no larger than 1024 bytes. Each frame has the following format:
//
//     <2:AAD for little endian length of encrypted data (n) in bytes>
//     <n:encrypted data according to AEAD algorithm, up to 1024 bytes>
//     <16:authTag according to AEAD algorithm>
class Cryptographer {
    enum Error: Swift.Error {
        case invalidArgument
        case indexOutOfBounds
    }

    var encryptCount: UInt64 = 0
    var decryptCount: UInt64 = 0
    let decryptKey: HAPSymmetricKey
    let encryptKey: HAPSymmetricKey

    init(sharedKey: HAPSharedSecret) {
        logger.debug("Shared key: \(sharedKey.hex)")
        decryptKey = Keys.deriveSha512(
                                    seed: sharedKey,
                                    info: "Control-Write-Encryption-Key".data(using: .utf8)!,
                                    salt: "Control-Salt".data(using: .utf8)!,
                                    count: 32)
        encryptKey = Keys.deriveSha512(
                                    seed: sharedKey,
                                    info: "Control-Read-Encryption-Key".data(using: .utf8)!,
                                    salt: "Control-Salt".data(using: .utf8)!,
                                    count: 32)
        logger.debug("Decrypt key: \(self.decryptKey.hex)")
        logger.debug("Encrypt key: \(self.encryptKey.hex)")
    }

    func decrypt(length: Int, cipher: inout ByteBuffer, message: inout ByteBuffer) throws {
        logger.info("Decrypt message #\(self.decryptCount), length: \(length)")
        defer { decryptCount += 1 }
        var lengthBytes = cipher.readSlice(length: 2)!
        let nonce = decryptCount.bigEndian.bytes
        try ChaCha20Poly1305.decrypt(cipher: &cipher,
                                     additional: &lengthBytes,
                                     nonce: nonce,
                                     key: decryptKey,
                                     message: &message)
    }

    func encrypt(length: Int, plaintext: inout ByteBuffer, cipher: inout ByteBuffer) throws {
        logger.info("Encrypt message #\(self.encryptCount), length: \(length)")
        defer { encryptCount += 1 }
        cipher.writeInteger(Int16(length), endianness: Endianness.little, as: Int16.self)
        let additional = cipher.viewBytes(at: 0, length: 2)!
        let nonce = encryptCount.bigEndian.bytes
        try ChaCha20Poly1305.encrypt(message: &plaintext,
                                     additional: additional,
                                     nonce: nonce,
                                     key: encryptKey,
                                     cipher: &cipher)
    }
}
