import Logging
import Foundation
import HKDF
import NIO
import Crypto

fileprivate let logger: Logger = {
    var _logger = Logger(label: "hap.encryption")
    _logger.logLevel = .warning
    return _logger
}()

extension ByteBuffer : ContiguousBytes {
    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try self.withUnsafeReadableBytes(body)
    }
}

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
    let decryptKey: Data
    let encryptKey: Data

    init(sharedKey: Data) {
        logger.debug("Shared key: \(sharedKey.hex)")
        decryptKey = HKDF.deriveKey(algorithm: .sha512,
                                    seed: sharedKey,
                                    info: "Control-Write-Encryption-Key".data(using: .utf8),
                                    salt: "Control-Salt".data(using: .utf8),
                                    count: 32)
        encryptKey = HKDF.deriveKey(algorithm: .sha512,
                                    seed: sharedKey,
                                    info: "Control-Read-Encryption-Key".data(using: .utf8),
                                    salt: "Control-Salt".data(using: .utf8),
                                    count: 32)
        logger.debug("Decrypt key: \(self.decryptKey.hex)")
        logger.debug("Encrypt key: \(self.encryptKey.hex)")
    }

    func decrypt<L: DataProtocol, C: DataProtocol, T: DataProtocol>(lengthBytes: L, ciphertext: C, tag: T) throws -> Data {
        logger.info("Decrypt message #\(self.decryptCount)")
        defer { decryptCount += 1 }

        let nonce = try ChaChaPoly.Nonce(data: Data(count: 4) + decryptCount.bigEndian.bytes)
        let box = try ChaChaPoly.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
        let key = SymmetricKey(data: decryptKey)

        return try ChaChaPoly.open(box, using: key, authenticating: lengthBytes)
    }

    func encrypt(plaintext: ByteBuffer) throws -> Data {
        logger.info("Encrypt message #\(self.encryptCount)")
        defer { encryptCount += 1 }

        let nonce = try ChaChaPoly.Nonce(data: Data(count: 4) + encryptCount.bigEndian.bytes)
        let key = SymmetricKey(data: encryptKey)
        let authenticationData = UInt16(plaintext.readableBytes).bigEndian.bytes

        let box = try ChaChaPoly.seal(plaintext.readableBytesView, using: key, nonce: nonce, authenticating: authenticationData)

        return authenticationData + box.ciphertext + box.tag
    }
}
