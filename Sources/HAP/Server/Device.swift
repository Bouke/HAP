import Cryptor
import Foundation
import Regex
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
    public let setupCode: String
    let storage: Storage
    let pairings: Pairings
    public let accessories: [Accessory]
    internal var characteristicEventListeners: [Box<Characteristic>: WeakObjectSet<Server.Connection>]
    public var onIdentify: [(Accessory?) -> Void] = []

    /// 2.5.3.2 Bridges
    /// A bridge is a special type of HAP accessory server that bridges HomeKit
    /// Accessory Protocol and different RF/transport protocols, such as ZigBee
    /// or Z-Wave. A bridge must expose all the user-addressable functionality
    /// supported by its connected devices as HAP accessory objects to the HAP
    /// controller(s). A bridge must ensure that the instance ID assigned to the
    /// HAP accessory objects exposed on behalf of its connected devices do not
    /// change for the lifetime of the server/client pairing.
    ///
    /// For example, a bridge that bridges three lights would expose four HAP
    /// accessory objects: one HAP accessory object that represents the bridge
    /// itself that may include a "firmware update" service, and three
    /// additional HAP accessory objects that each contain a "lightbulb"
    /// service.
    ///
    /// A bridge must not expose more than 100 HAP accessory objects.
    ///
    /// Any accessories, regardless of transport, that enable physical access to
    /// the home, such as door locks, must not be bridged. Accessories that
    /// support IP transports, such as Wi-Fi, must not be bridged. Accessories
    /// that support Bluetooth LE that can be controlled, such as a light bulb,
    /// must not be bridged. Accessories that support Bluetooth LE that only
    /// provide data, such as a temperature sensor, and accessories that support
    /// other transports, such as a ZigBee light bulb or a proprietary RF
    /// sensor, may be bridged.
    ///
    /// - Parameters:
    ///   - bridgeInfo: information about the bridge
    ///   - setupCode: the code to pair this device, must be in the format XXX-XX-XXX
    ///   - storage: persistence interface for storing pairings, secrets
    ///   - accessories: accessories to be bridged
    convenience public init(
        bridgeInfo: Service.Info,
        setupCode: String,
        storage: Storage,
        accessories: [Accessory]) {
        let bridge = Accessory(info: bridgeInfo, type: .bridge, services: [])
        self.init(name: bridge.info.name.value!,
                  setupCode: setupCode,
                  storage: storage,
                  accessories: [bridge] + accessories)
    }

    convenience public init(
        setupCode: String,
        storage: Storage,
        accessory: Accessory) {
        self.init(name: accessory.info.name.value!,
                  setupCode: setupCode,
                  storage: storage,
                  accessories: [accessory])
    }

    fileprivate init(
        name: String,
        setupCode: String,
        storage: Storage,
        accessories: [Accessory]) {
        precondition(setupCode =~ "^\\d{3}-\\d{2}-\\d{3}",
                     "setup code must conform to the format XXX-XX-XXX")
        self.name = name
        self.setupCode = setupCode
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
            // Current configuration number. Required.
            // Must update when an accessory, service, or characteristic is
            // added or removed on the accessory server.
            // Accessories must increment the config number after a firmware
            // update. This must have a range of 1-4294967295 and wrap to 1
            // when it overflows. This value must persist across reboots, power
            // cycles, etc.
            "c#": "3",

            // Feature flags (e.g. "0x3" for bits 0 and 1). Required if
            // non-zero. See table:
            // 0x01         1   Supports HAP Pairing. This flag is required for
            //                  all HomeKit accessories.
            // 0x02-0x80    2-8 Reserved.
            "ff": "0x01",

            // Device ID (Device ID (page 36)) of the accessory. The Device ID
            // must be formatted as "XX:XX:XX:XX:XX:XX", where "XX" is a
            // hexadecimal string representing a byte. Required.
            // This value is also used as the accessory's Pairing Identifier.
            "id": identifier, // identifier

            // Model name of the accessory (e.g. "Device1,1"). Required.
            "md": name, // name

            // Protocol version string <major>.<minor> (e.g. "1.0"). Required
            // if value is not "1.0".
            // The client should check this before displaying an accessory to
            // the user. If the major version is greater than the major version
            // the client software was built to support, it should hide the
            // accessory from the user. A change in the minor version indicates
            // the protocol is still compatible. This mechanism allows future
            // versions of the protocol to hide itself from older clients that
            // may not know how to handle it.
            "pv": "1.0",

            // Current state number. Required. This must have a value of "1".
            "s#": "1",

            // Status flags (e.g. "0x04" for bit 3). Value should be an
            // unsigned integer. Required if non-zero. See table:
            // 0x01         1   Accessory has not been paired with any controllers.
            // 0x02-0x80    2   Accessory has not been configured to join a Wi-Fi network.
            // 0x04         3   A problem has been detected on the accessory.
            // 0x08-0x80    4-8 Reserved.
            "sf": (isPaired ? "0" : "0x01"),

            // Accessory Category Identifier. Required. Indicates the category
            // that best describes the primary function of the accessory. This
            // must have a range of 1-65535. This must take values defined in
            // Table 12-3 (page 254). This must persist across reboots, power
            // cycles, etc.
            "ci": category.rawValue // category identifier
        ]
    }
}
