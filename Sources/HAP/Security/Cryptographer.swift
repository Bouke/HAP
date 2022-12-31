import Crypto
import Foundation
import NIO

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
    let decryptKey: SymmetricKey
    let encryptKey: SymmetricKey

    init(sharedSecret: SymmetricKey) {
        decryptKey = Cryptographer.deriveDecryptionKey(sharedSecret: sharedSecret)
        encryptKey = Cryptographer.deriveEncryptionKey(sharedSecret: sharedSecret)
    }

    static func deriveDecryptionKey(sharedSecret: SymmetricKey) -> SymmetricKey {
        HKDF<SHA512>.deriveKey(inputKeyMaterial: sharedSecret,
                               salt: "Control-Salt".data(using: .utf8)!,
                               info: "Control-Write-Encryption-Key".data(using: .utf8)!,
                               outputByteCount: 32)
    }

    static func deriveEncryptionKey(sharedSecret: SymmetricKey) -> SymmetricKey {
        HKDF<SHA512>.deriveKey(inputKeyMaterial: sharedSecret,
                               salt: "Control-Salt".data(using: .utf8)!,
                               info: "Control-Read-Encryption-Key".data(using: .utf8)!,
                               outputByteCount: 32)
    }

    func decrypt<L: DataProtocol, C: DataProtocol, T: DataProtocol>(lengthBytes: L,
                                                                    ciphertext: C,
                                                                    tag: T) throws -> Data {
        defer { decryptCount += 1 }

        let nonce = try ChaChaPoly.Nonce(data: Data(count: 4) + decryptCount.littleEndianBytes)
        let box = try ChaChaPoly.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)

        return try ChaChaPoly.open(box, using: decryptKey, authenticating: lengthBytes)
    }

    func encrypt(plaintext: ByteBuffer) throws -> Data {
        defer { encryptCount += 1 }

        let nonce = try ChaChaPoly.Nonce(data: Data(count: 4) + encryptCount.littleEndianBytes)
        let authenticationData = UInt16(plaintext.readableBytes).littleEndianBytes

        let box = try ChaChaPoly.seal(plaintext.readableBytesView,
                                      using: encryptKey,
                                      nonce: nonce,
                                      authenticating: authenticationData)

        return authenticationData + box.ciphertext + box.tag
    }
}
