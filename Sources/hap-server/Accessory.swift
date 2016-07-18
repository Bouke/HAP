import Foundation
import CLibSodium
import CommonCrypto

func generateIdentifier() -> String {
    return (1...6).map({ _ in String(arc4random() & 255, radix: 16, uppercase: false) }).joined(separator: ":")
}

class Client {
    let username: String
    let publicKey: Data

    init(username: String, publicKey: Data) {
        self.username = username
        self.publicKey = publicKey
    }
}

class Accessory {
    let name: String

    init(name: String) {
        self.name = name
    }
}

class Device {
    let name: String
    let identifier: String
    let publicKey: Data
    let privateKey: Data
    let pin: String

    convenience init(name: String, pin: String) {
        let (pk, sk) = Ed25519.generateSignKeypair()
        self.init(name: name, identifier: generateIdentifier(), pin: pin, publicKey: pk, privateKey: sk)
    }

    init(name: String, identifier: String, pin: String, publicKey: Data, privateKey: Data) {
        self.name = name
        self.identifier = identifier
        self.pin = pin
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
}
