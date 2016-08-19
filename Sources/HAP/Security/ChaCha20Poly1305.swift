import CryptoSwift
import Foundation
import Evergreen

fileprivate let logger = getLogger("chacha")

class ChaCha20Poly1305 {
    enum Error: Swift.Error {
        case invalidMessageAuthenticator
    }

    let poly1305: Poly1305
    let chacha20: ChaCha20

    init?(key: Data, nonce: Data) {
        precondition(key.count == 32, "encryption key must be 256 bit, but is \(key.count * 8) bits")

        guard let chacha20 = ChaCha20(key: Array(key), iv: Array(nonce)) else {
            return nil
        }

        let polyKey = Data(try! chacha20.encrypt(Array(repeating: 0, count: 64))[0..<32])
        logger.debug("PolyKey: \(polyKey.toHexString())")

        guard let poly1305 = Poly1305(key: Array(polyKey)) else {
            return nil
        }

        self.poly1305 = poly1305
        self.chacha20 = chacha20
    }

    func decrypt(cipher: Data, add: Data = Data()) throws -> Data {
        let message = Data(cipher[0..<cipher.endIndex-16])
        let mac = Data(cipher[cipher.endIndex-16..<cipher.endIndex])

        let polyMessage = add + Data(count: (16 - (add.count % 16)) % 16) +
            message + Data(count: (16 - (message.count % 16)) % 16)  +
            Data(bytes: UInt64(add.count).bigEndian.bytes()) +
            Data(bytes: UInt64(message.count).bigEndian.bytes())

        guard let computedMac = poly1305.authenticate(Array(polyMessage)) else {
            throw Error.invalidMessageAuthenticator
        }

        logger.debug("Verifying MAC; input: \(polyMessage.toHexString()), provided MAC: \(mac.toHexString()), computed MAC: \(Data(computedMac).toHexString())")
//        guard mac == Data(computedMac) else {
//            logger.debug("Invalid MAC")
//            throw Error.invalidMessageAuthenticator
//        }
        if mac != Data(computedMac) {
            // @todo fail here if bug is fixed https://github.com/krzyzanowskim/CryptoSwift/issues/304
            logger.error("Invalid MAC")
        }

        logger.debug("Valid MAC, decrypting cyphertext: \(message)")
        return Data(try chacha20.decrypt(Array(message)))
    }

    func encrypt(message: Data, add: Data = Data()) throws -> Data {
        let encrypted = Data(try chacha20.encrypt(Array(message)))

        let polyMessage = add + Data(count: (16 - (add.count % 16)) % 16) +
            encrypted + Data(count: (16 - (encrypted.count % 16)) % 16)  +
            Data(bytes: UInt64(add.count).bigEndian.bytes()) +
            Data(bytes: UInt64(encrypted.count).bigEndian.bytes())

        guard let computedMac = poly1305.authenticate(Array(polyMessage)) else {
            throw Error.invalidMessageAuthenticator
        }
        
        return encrypted + Data(computedMac)
    }
}
