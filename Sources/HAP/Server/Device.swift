import Cryptor
import Foundation
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap")

func generateIdentifier() -> String {
    return try! Random.generate(byteCount: 6)
        .map { String($0, radix: 16, uppercase: false) }
        .joined(separator: ":")
}

struct Box<T: Any>: Hashable, Equatable {
    let value: T

    init(_ value: T) {
        self.value = value
    }
    
    var object: AnyObject {
        #if os(macOS)
            return value as AnyObject
        #elseif os(Linux)
            return value as! AnyObject
        #endif
    }

    var hashValue: Int {
        return ObjectIdentifier(object).hashValue
    }

    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        return ObjectIdentifier(lhs.object) == ObjectIdentifier(rhs.object)
    }
}

public class Device {
    public let name: String
    public let identifier: String
    public let publicKey: Data
    let privateKey: Data
    public let pin: String
    let storage: Storage
    let clients: Clients
    public let accessories: [Accessory]
    internal var characteristicEventListeners: [Box<Characteristic>: WeakObjectSet<Server.Connection>]
    public var onIdentify: [(Accessory?) -> ()] = []

    public init(name: String, pin: String, storage: Storage, accessories: [Accessory]) {
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

        for (offset, accessory) in accessories.enumerated() {
            accessory.aid = offset + 1
            accessory.device = self
        }
    }

    public class Clients {
        private let storage: Storage
        fileprivate init(storage: Storage) {
            self.storage = storage
        }

        public subscript(username: Data) -> Data? {
            get {
                return storage[username.hex]
            }
            set {
                storage[username.hex] = newValue
            }
        }
    }

    public var isPaired: Bool {
        // @todo if number of clients > 0 return true
        return false
    }

    func add(characteristic: Characteristic, listener: Server.Connection) {
        if let _ = characteristicEventListeners[Box(characteristic)] {
            characteristicEventListeners[Box(characteristic)]!.addObject(object: listener)
        } else {
            characteristicEventListeners[Box(characteristic)] = [listener]
        }
    }

    @discardableResult
    func remove(characteristic: Characteristic, listener connection: Server.Connection) -> Server.Connection? {
        guard let _ = characteristicEventListeners[Box(characteristic)] else {
            return nil
        }
        return characteristicEventListeners[Box(characteristic)]!.remove(connection)
    }

    func notify(characteristicListeners characteristic: Characteristic, exceptListener except: Server.Connection? = nil) {
        guard let listeners = characteristicEventListeners[Box(characteristic)]?.filter({$0 != except}), listeners.count > 0 else {
            return logger.info("Value changed, but nobody listening")
        }
        guard let event = Event(valueChangedOfCharacteristic: characteristic) else {
            return logger.error("Could not create value change event")
        }
        let data = event.serialized()
        logger.info("Value changed, notifying \(listeners.count) listener(s)")
        logger.debug("Listeners: \(listeners), event: \(event)")
        for listener in listeners {
            listener.writeOutOfBand(data)
        }
    }

    var config: [String: String] {
        let category: AccessoryType = accessories.count == 1 ? accessories[0].type : .bridge

        return [
            "pv": "1.0", // state
            "id": identifier, // identifier
            "c#": "1", // version
            "s#": "1", // state
            "sf": (isPaired ? "0" : "1"), // discoverable
            "ff": "0", // mfi compliant
            "md": name, // name
            "ci": category.rawValue // category identifier
        ]
    }
}
