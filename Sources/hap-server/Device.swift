import Foundation
import HTTP
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap")

func generateIdentifier() -> String {
    return (1...6).map({ _ in String(arc4random() & 255, radix: 16, uppercase: false) }).joined(separator: ":")
}

public class Device {
    let name: String
    let identifier: String
    let publicKey: Data
    let privateKey: Data
    let pin: String
    let storage: FileStorage
    let clients: Clients
    let accessories: [Accessory]
    internal var characteristicEventListeners: [Characteristic: WeakObjectSet<Connection>]

    init(name: String, pin: String, storage: FileStorage, accessories: [Accessory]) {
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
        self.accessories = accessories
        characteristicEventListeners = [:]
    }

    public class Clients {
        private let storage: FileStorage
        fileprivate init(storage: FileStorage) {
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

    var isPaired: Bool {
        // @todo if number of clients > 0 return true
        return false
    }

    public func add(characteristic: Characteristic, listener: Connection) {
        if let _ = characteristicEventListeners[characteristic] {
            characteristicEventListeners[characteristic]!.addObject(object: listener)
        } else {
            characteristicEventListeners[characteristic] = [listener]
        }
    }

    @discardableResult
    public func remove(characteristic: Characteristic, listener connection: Connection) -> Connection? {
        guard let _ = characteristicEventListeners[characteristic] else {
            return nil
        }
        return characteristicEventListeners[characteristic]!.remove(connection)
    }

    public func notify(characteristicListeners characteristic: Characteristic, event: Event, exceptListener except: Connection? = nil) {
        guard let listeners = characteristicEventListeners[characteristic]?.filter({$0 != except}) else {
            return
        }
        let data = event.serialized()

        logger.info("Notifying \(listeners): \(event)")
        for listener in listeners {
            listener.write(data)
        }
    }
}

