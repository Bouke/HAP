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

public class Device {
    let name: String
    let identifier: String
    let publicKey: Data
    let privateKey: Data
    let pin: String
    let storage: FileStorage
    let clients: Clients

    init(name: String, pin: String, storage: FileStorage) {
        self.name = name
        self.pin = pin
        self.storage = storage
        if let pk = storage["pk"], let sk = storage["sk"], let identifier = storage["uuid"] {
            self.identifier = String(data: identifier, encoding: .utf8)!
            self.publicKey = pk
            self.privateKey = sk
        } else {
            (self.publicKey, self.privateKey) = Ed25519.generateSignKeypair()
            self.identifier = generateIdentifier()
            storage["pk"] = self.publicKey
            storage["sk"] = self.privateKey
            storage["uuid"] = identifier.data(using: .utf8)
        }
        clients = Clients(storage: storage)
    }

    public class Clients {
        private let storage: FileStorage
        private init(storage: FileStorage) {
            self.storage = storage
        }

        public subscript(username: Data) -> Data? {
            get {
                return storage[username.toHexString()]
            }
            set {
                storage[username.toHexString()] = newValue
            }
        }
    }
}
