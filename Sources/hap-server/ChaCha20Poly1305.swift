import CryptoSwift
import Foundation

class ChaCha20Poly1305 {
    enum Error: ErrorProtocol {
        case InvalidMessageAuthenticator
    }

    let poly1305: Poly1305
    let chacha20: ChaCha20

    init?(key: Data, nonce: Data) {
        guard let chacha20 = ChaCha20(key: Array(key), iv: Array(nonce)) else {
            return nil
        }

        let polyKey = Data(try! chacha20.decrypt(Array(repeating: 0, count: 64))[0..<32])

        guard let poly1305 = Poly1305(key: Array(polyKey)) else {
            return nil
        }

        self.poly1305 = poly1305
        self.chacha20 = chacha20
    }

    func decrypt(cipher: Data, add: Data = Data()) throws -> Data {
        let message = Data(cipher[0..<cipher.endIndex-16])
        let mac = Data(cipher[cipher.endIndex-16..<cipher.endIndex])

        let polyMessage = add + Data(repeating: 0, count: (16 - (add.count % 16)) % 16) +
            message + Data(repeating: 0, count: (16 - (message.count % 16)) % 16)  +
            Data(bytes: UInt64(add.count).bigEndian.bytes()) +
            Data(bytes: UInt64(message.count).bigEndian.bytes())

        guard let computedMac = poly1305.authenticate(Array(polyMessage)) else {
            throw Error.InvalidMessageAuthenticator
        }

        guard mac == Data(computedMac) else {
            throw Error.InvalidMessageAuthenticator
        }

        return Data(try chacha20.decrypt(Array(message)))
    }
}
