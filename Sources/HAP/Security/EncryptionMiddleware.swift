import Foundation
import HTTP
import HKDF
import Evergreen
import CryptoSwift

fileprivate let logger = getLogger("encryption")

class UpgradeResponse: Response {
    let cryptographer: Cryptographer
    init(cryptographer: Cryptographer) {
        self.cryptographer = cryptographer
        super.init(status: .ok)
    }
}

public class Cryptographer {
    var encryptCount: UInt64 = 0
    var decryptCount: UInt64 = 0
    let decryptKey: Data
    let encryptKey: Data

    public init(sharedKey: Data) {
        logger.info("Shared key: \(sharedKey.hex)")
        decryptKey = HKDF.deriveKey(algorithm: .SHA512, seed: sharedKey, info: "Control-Write-Encryption-Key".data(using: .utf8)!, salt: "Control-Salt".data(using: .utf8)!, count: 32)
        encryptKey = HKDF.deriveKey(algorithm: .SHA512, seed: sharedKey, info: "Control-Read-Encryption-Key".data(using: .utf8)!, salt: "Control-Salt".data(using: .utf8)!, count: 32)
        logger.debug("Decrypt key: \(self.decryptKey.hex)")
        logger.debug("Encrypt key: \(self.encryptKey.hex)")
    }

    public func decrypt(_ data: Data) throws -> Data {
        defer { decryptCount += 1 }

        logger.info("Decrypt message #\(self.decryptCount)")
        logger.info("Data: \(data.hex)")
        guard data.count > 0 else {
            logger.warning("No ciphertext")
            return data
        }

        let length = Int(UInt16(data: Data(data[0..<2])))
        precondition(length + 2 + 16 == data.count)

        let nonce = Data(bytes: decryptCount.bigEndian.bytes())
        let encrypted = data[2..<(2 + length + 16)]
        logger.debug("Ciphertext: \(encrypted.hex), Nonce: \(nonce.hex), Length: \(length)")
        
        return try ChaCha20Poly1305.decrypt(cipher: Data(encrypted), additional: Data(data[0..<2]), nonce: nonce, key: decryptKey)
    }

    public func encrypt(_ data: Data) throws -> Data {
        defer { encryptCount += 1 }
        logger.info("Encrypt message: \(self.encryptCount)")

        let nonce = Data(bytes: encryptCount.bigEndian.bytes())
        let length = Data(UInt16(data.count).bytes.reversed())
        logger.debug("Message: \(data.hex), Nonce: \(nonce.hex), Length: \(length.hex)")

        let encrypted = try ChaCha20Poly1305.encrypt(message: data, additional: length, nonce: nonce, key: encryptKey)
        logger.debug("Cipher: \((length + encrypted).hex)")
        
        return length + encrypted
    }
}

public class EncryptionMiddleware: StreamMiddleware {
    public init() { }

    public func parse(input data: Data, forConnection connection: Connection) -> Data {
        if let cryptographer = connection.context["cryptographer"] as? Cryptographer {
            return try! cryptographer.decrypt(data)
        }
        return data
    }

    public func parse(output data: Data, forConnection connection: Connection) -> Data {
        if let cryptographer = connection.context["cryptographer"] as? Cryptographer {
            return try! cryptographer.encrypt(data)
        }
        if let response = connection.response as? UpgradeResponse {
            connection.context["cryptographer"] = response.cryptographer
        }
        return data
    }
}
