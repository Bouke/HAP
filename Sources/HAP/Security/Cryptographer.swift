import Evergreen
import Foundation
import HKDF

fileprivate let logger = getLogger("hap.encryption")

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

    func decrypt(_ data: Data) throws -> Data {
        guard !data.isEmpty else {
            throw Error.invalidArgument
        }
        logger.info("Decrypt message #\(self.decryptCount), length: \(data.count)")
        logger.debug("Message cipher: \(data.hex)")
        var buffer = Data()
        var position = data.startIndex
        repeat {
            defer { decryptCount += 1 }
            let lengthBytes = data[position..<(position + 2)]
            let length = Int(UInt16(data: lengthBytes))
            guard position + 2 + length + 16 <= data.endIndex else {
                throw Error.indexOutOfBounds
            }
            let nonce = decryptCount.bigEndian.bytes
            let cipher = data[(position + 2)..<(position + 2 + length + 16)]
            logger.debug("Ciphertext: \(cipher.hex), Nonce: \(nonce.hex), Length: \(length)")
            buffer += try ChaCha20Poly1305.decrypt(cipher: cipher,
                                                   additional: lengthBytes,
                                                   nonce: nonce,
                                                   key: decryptKey)
            data.formIndex(&position, offsetBy: 2 + length + 16)
        } while position < data.endIndex
        logger.debug("Message data: \(data.hex)")
        return buffer
    }

    func encrypt(_ data: Data) throws -> Data {
        logger.info("Encrypt message #\(self.encryptCount), length: \(data.count)")
        logger.debug("Message data: \(data.hex)")
        var buffer = Data()
        var position = data.startIndex
        repeat {
            defer { encryptCount += 1 }
            let length = min(data.endIndex - position, 1024)
            let chunk = data[position..<(position + length)]
            let nonce = encryptCount.bigEndian.bytes
            let lengthBytes = UInt16(length).bigEndian.bytes
            logger.debug("Chunk: \(chunk.hex), Nonce: \(nonce.hex), Length: \(lengthBytes.hex)")
            let encrypted = try ChaCha20Poly1305.encrypt(message: chunk,
                                                         additional: lengthBytes,
                                                         nonce: nonce,
                                                         key: encryptKey)
            buffer += lengthBytes + encrypted
            data.formIndex(&position, offsetBy: length)
        } while position < data.endIndex
        logger.debug("Cipher: \(buffer.hex)")
        return buffer
    }
}
