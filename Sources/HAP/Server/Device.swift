import Foundation
import HTTP
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap")

func generateIdentifier() -> String {
    return (1...6).map({ _ in String(arc4random() & 255, radix: 16, uppercase: false) }).joined(separator: ":")
}

struct Box<T: Any>: Hashable, Equatable {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    var hashValue: Int {
        return ObjectIdentifier(value as AnyObject).hashValue
    }

    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        return ObjectIdentifier(lhs.value as AnyObject) == ObjectIdentifier(rhs.value as AnyObject)
    }
}

public class Device {
    public let name: String
    public let identifier: String
    public let publicKey: Data
    let privateKey: Data
    public let pin: String
    let storage: FileStorage
    let clients: Clients
    public let accessories: [Accessory]
    internal var characteristicEventListeners: [Box<AnyCharacteristic>: WeakObjectSet<Connection>]
    public var onIdentify: [() -> ()] = []

    public init(name: String, pin: String, storage: FileStorage, accessories: [Accessory]) {
        self.name = name
        self.pin = pin
        self.storage = storage
        if let pk = storage["pk"], let sk = storage["sk"], let identifier = storage["uuid"] {
            self.identifier = String(data: identifier, encoding: .utf8)!
            publicKey = pk
            privateKey = sk
        } else {
            (publicKey, privateKey) = Ed25519.generateSignKeypair()
            identifier = generateIdentifier()
            storage["pk"] = publicKey
            storage["sk"] = privateKey
            storage["uuid"] = identifier.data(using: .utf8)
        }
        clients = Clients(storage: storage)
        self.accessories = accessories
        characteristicEventListeners = [:]

        for accessory in accessories {
            accessory.device = self
        }
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

    public var isPaired: Bool {
        // @todo if number of clients > 0 return true
        return false
    }

    func add(characteristic: AnyCharacteristic, listener: Connection) {
        if let _ = characteristicEventListeners[Box(characteristic)] {
            characteristicEventListeners[Box(characteristic)]!.addObject(object: listener)
        } else {
            characteristicEventListeners[Box(characteristic)] = [listener]
        }
    }

    @discardableResult
    func remove(characteristic: AnyCharacteristic, listener connection: Connection) -> Connection? {
        guard let _ = characteristicEventListeners[Box(characteristic)] else {
            return nil
        }
        return characteristicEventListeners[Box(characteristic)]!.remove(connection)
    }

    func notify(characteristicListeners characteristic: AnyCharacteristic, exceptListener except: Connection? = nil) {
        guard let listeners = characteristicEventListeners[Box(characteristic)]?.filter({$0 != except}), listeners.count > 0, let event = Event(valueChangedOfCharacteristic: characteristic) else {
            logger.warning("Value changed, but not notifying (either no listeners or could not serialize)")
            return
        }
        let data = event.serialized()
        logger.info("Notifying \(listeners): \(event)")
        for listener in listeners {
            listener.write(data)
        }
    }

    var config: [String: Data] {
        let category: AccessoryType = accessories.count == 1 ? accessories[0].type : .bridge

        return [
            "pv": "1.0".data(using: .utf8)!, // state
            "id": identifier.data(using: .utf8)!, // identifier
            "c#": "1".data(using: .utf8)!, // version
            "s#": "1".data(using: .utf8)!, // state
            "sf": (isPaired ? "0" : "1").data(using: .utf8)!, // discoverable
            "ff": "0".data(using: .utf8)!, // mfi compliant
            "md": name.data(using: .utf8)!, // name
            "ci": category.rawValue.data(using: .utf8)! // category identifier
        ]
    }
}
