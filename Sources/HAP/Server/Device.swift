import Cryptor
import Foundation
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.device")

func generateIdentifier() -> String {
    do {
        return Data(bytes: try Random.generate(byteCount: 6))
            .map { String($0, radix: 16, uppercase: false) }
            .joined(separator: ":")
    } catch {
        fatalError("Could not generate identifier: \(error)")
    }
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
    let pairings: Pairings
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
        pairings = Pairings(storage: PrefixedKeyStorage(prefix: "pairing.", backing: storage))
        self.accessories = accessories
        characteristicEventListeners = [:]

        // 2.6.1.1 Accessory Instance IDs
        // Accessory instance IDs, "aid", are assigned from the same number
        // pool that is global across entire HAP Accessory Server. For example,
        // if the first Accessory object has an instance ID of "1" then no
        // other Accessory object can have an instance ID of "1" within the
        // Accessory Server.
        //
        // TODO: SwiftFoundation in Swift 4.0 cannot encode/decode UInt64,
        // which is the data-type we wanted to use here. We can change it back
        // to UInt64 once the following commit has made it into a release:
        // https://github.com/apple/swift-corelibs-foundation/commit/64b67c91479390776c43a96bd31e4e85f106d5e1
        var idGenerator = (1...Int.max).makeIterator()
        for accessory in accessories {
            accessory.device = self
            accessory.aid = idGenerator.next()!
        }
    }

    class Pairings {
        fileprivate let storage: Storage
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
        return !pairings.storage.keys.isEmpty
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
            return logger.debug("Value changed, but nobody listening")
        }

        for listener in listeners {
            listener.notificationQueue.append(characteristic: characteristic)
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
