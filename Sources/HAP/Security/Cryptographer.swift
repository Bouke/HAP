import Foundation
import HKDF
import Evergreen

fileprivate let logger = getLogger("hap.encryption")

class UpgradeResponse: Response {
    let cryptographer: Cryptographer
    init(cryptographer: Cryptographer) {
        self.cryptographer = cryptographer
        super.init(status: .ok)
    }
}

class Cryptographer {
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
        defer { decryptCount += 1 }

        logger.debug("Decrypt message #\(self.decryptCount)")
        logger.debug("Data: \(data.hex)")
        guard data.count > 0 else {
            logger.warning("No ciphertext")
            return data
        }

        let length = Int(UInt16(data: Data(data[0..<2])))
        precondition(length + 2 + 16 == data.count)

        let nonce = decryptCount.bigEndian.bytes
        let encrypted = data[2..<(2 + length + 16)]
        logger.debug("Ciphertext: \(encrypted.hex), Nonce: \(nonce.hex), Length: \(length)")

        return try ChaCha20Poly1305.decrypt(cipher: Data(encrypted), additional: Data(data[0..<2]), nonce: nonce, key: decryptKey)
    }

    func encrypt(_ data: Data) throws -> Data {
        defer { encryptCount += 1 }
        logger.debug("Encrypt message #\(self.encryptCount)")

        let nonce = encryptCount.bigEndian.bytes
        let length = UInt16(data.count).bigEndian.bytes
        logger.debug("Message: \(data.hex), Nonce: \(nonce.hex), Length: \(length.hex)")

        let encrypted = try ChaCha20Poly1305.encrypt(message: data, additional: length, nonce: nonce, key: encryptKey)
        logger.debug("Cipher: \((length + encrypted).hex)")

        return length + encrypted
    }
}
