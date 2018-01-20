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
    public var accessories: [Accessory]
    internal var characteristicEventListeners: [Box<Characteristic>: WeakObjectSet<Server.Connection>]
    public var onIdentify: [(Accessory?) -> Void] = []
    internal var configuration : Configuration
    internal var onConfigurationChange: [(Device) -> Void] = []

    // The device maitains a configuration number during its life time, which persists across restarts of the app

    //    Current configuration number.
    //    Must update when an accessory, service, or characteristic is added or removed on the accessory server.
    //    Accessories must increment the config number after a firmware update.
    //    This must have a range of 1-4294967295 and wrap to 1 when it overflows.
    //    This value must persist across reboots, power cycles, etc.
    //
    //    Accessory instance IDs, "aid", are assigned from the same number pool that is global across
    //    entire HAP Accessory Server. For example, if the first Accessory object has an instance ID of "1"
    //    then no other Accessory object can have an instance ID of "1" within the Accessory Server.
    //
    //    Instance IDs are numbers with a range of [1, 18446744073709551615]. These numbers are used to
    //    uniquely identify HAP accessory objects within an HAP accessory server, or uniquely identify
    //    services, and characteristics within an HAP accessory object. The instance ID for each object
    //    must be unique for the lifetime of the server/ client pairing.
    
    internal struct AIDGenerator : Sequence, IteratorProtocol, Codable {
        internal var lastAID: InstanceID = 1
        mutating func next() -> InstanceID? {
            lastAID = lastAID &+ 1 // Add one and overflow if reach max InstanceID
            if lastAID < 2 {
                lastAID = 2
            }
            return lastAID
        }
    }
    
    internal struct Configuration : Codable {
        internal var number: UInt32 = 0
        internal var aidForAccessorySerialNumber = [String : InstanceID]()
        private var aidGenerator = AIDGenerator()

        // The next aid - should be checked against existing devices to ensure it is unique
        internal mutating func nextAID() -> InstanceID {
            return aidGenerator.next()!
        }
        
        // Write the configuration record to storage
        internal func writeTo(_ storage: Storage) {
            do {
                let encoder = JSONEncoder()
                let configData = try encoder.encode(self)
                storage["configuration"] = configData
            } catch {
                logger.error("Error encoding configuration data: \(error)")
            }
        }
    }
    
    
    // When a configuration changes
    // - update the configuration number
    // - write the configuration to storage
    // - notify interested parties of the change
    //
    func updatedConfiguration() {
        configuration.number = configuration.number &+ 1
        if configuration.number < 1 {
            configuration.number = 1
        }
        
        configuration.writeTo(storage)
        
        notifyConfigurationChange()

    }
    
    // Notify listeners that the config record has changed
    
    func notifyConfigurationChange() {
        _ = onConfigurationChange.map { $0(self) }
    }



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

    /// An HAP accessory object represents a physical accessory on an HAP
    /// accessory server. For example, a thermostat would expose a single HAP
    /// accessory object that represents the user-addressable functionality of
    /// the thermostat.
    ///
    /// - Parameters:
    ///   - setupCode: the code to pair this device, must be in the format XXX-XX-XXX
    ///   - storage: persistence interface for storing pairings, secrets
    ///   - accessory: accessory to publish
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
        self.configuration = Configuration() // default configuration

        if let pk = storage["pk"], let sk = storage["sk"], let identifier = storage["uuid"] {
            self.identifier = String(data: identifier, encoding: .utf8)!
            publicKey = pk
            privateKey = sk
            if let configData = storage["configuration"] {
                do {
                    let decoder = JSONDecoder()
                    configuration = try decoder.decode(Configuration.self, from: configData)
                } catch {
                    logger.error("Error reading configuration data: \(error)")
                }
            }
        } else {
            (publicKey, privateKey) = Ed25519.generateSignKeypair()
            identifier = generateIdentifier()
            
            configuration.writeTo(storage)
            
            storage["pk"] = publicKey
            storage["sk"] = privateKey
            storage["uuid"] = identifier.data(using: .utf8)
        }
        pairings = Pairings(storage: PrefixedKeyStorage(prefix: "pairing.", backing: storage))
        characteristicEventListeners = [:]

        // 2.6.1.1 Accessory Instance IDs
        // Accessory instance IDs, "aid", are assigned from the same number
        // pool that is global across entire HAP Accessory Server. For example,
        // if the first Accessory object has an instance ID of "1" then no
        // other Accessory object can have an instance ID of "1" within the
        // Accessory Server.
        //

        // Obtain new aid's for any accessories which don't already have one

        self.accessories = [Accessory]()

        // The first accessory must be aid 1
        accessories[0].aid = 1
        
        addAccessories(accessories)
    }
    
    public func addAccessories(_ newAccessories: [Accessory]) {
 
        var configurationUpdated = false
        
        accessories.append(contentsOf: newAccessories)
        
        // Remove any acessories with duplicate serial numbers
        for i in 0..<accessories.count {
            let accessory = accessories[i]
            let serialNumber = accessory.uniqueSerialNumber
            if !isUniqueSerialNumber(serialNumber, ignoring: accessory) {
                logger.info("Accessories must have unique serial numbers. Duplicate found '\(serialNumber)'. Second device ignored")
                accessories.remove(at: i)
            }
        }
        // Check to see if the aid has been stored in the configuration data
        for accessory in newAccessories {
            accessory.device = self
            if (accessory.aid == 0) {
                let serialNumber = accessory.uniqueSerialNumber
                if let aid = configuration.aidForAccessorySerialNumber[serialNumber] {
                    accessory.aid = aid
                }
            }
        }
        // Generate new aid if one is not already found or provided
        for accessory in newAccessories {
            // Verify that the aid is indeed unique
            if accessory.aid != 0,
               !isUniqueAID(accessory.aid, ignoring: accessory) {
                logger.info("Accessory \(accessory.info.name.value ?? "unknown") has a duplicate accessory ID \(accessory.aid), replacing with fresh IID")
                accessory.aid = 0
            }
            if (accessory.aid == 0) {
                // Obtain a new aid, which has not already been used
                repeat {
                    accessory.aid = configuration.nextAID()
                } while (!isUniqueAID(accessory.aid, ignoring: accessory))
                configurationUpdated = true

                // Store the aid in the configuration data
                
                let serialNumber = accessory.uniqueSerialNumber
                configuration.aidForAccessorySerialNumber[serialNumber] = accessory.aid
            }
        }
        
        // write configuration data to persist updated aid's and notify listeners
        
        if configurationUpdated {
            updatedConfiguration()
        }

        
    }
    
    public func removeAccessories(_ unwantedAccessories: [Accessory]) {
        
        if unwantedAccessories.count == 0 {
            return
        }
        
        for accessory in unwantedAccessories {
            // Ensure the initial accessory is not removed, and that the accessory is in the list
            
            precondition(accessory.aid != 1, "Cannot remove the Bridge Accessory from a Device")
            
            guard let index = accessories.index(where: { $0 === accessory}) else {
                preconditionFailure("Removing a non-existant accessory from the Bridge")
            }
            
            accessories.remove(at: index)
            
            let serialNumber = accessory.uniqueSerialNumber
            configuration.aidForAccessorySerialNumber.removeValue(forKey: serialNumber)
            
        }
        
        // write configuration data to persist updated aid's
        
        updatedConfiguration()

    }

    
    // Check if a given serial number is unique amoungst all acessories, except the one being tested
    func isUniqueSerialNumber(_ serialNumber: String, ignoring: Accessory) -> Bool {
        if serialNumber == "" {
            return false
        }
        for accessory in accessories {
            if accessory !== ignoring {
                if accessory.uniqueSerialNumber == serialNumber {
                    return false
                }
            }
        }
        return true
    }

    
    // Check if a given aid is unique amoungst all acessories, except the one being tested
    func isUniqueAID(_ aid: InstanceID, ignoring: Accessory) -> Bool {
        if aid == 0 {
            return false
        }
        for accessory in accessories {
            if accessory !== ignoring {
                if accessory.aid == aid {
                    return false
                }
            }
        }
        return true
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
    
    // Add the pairing to the internal DB and notify the change
    // to update the Bonjour broadcast
    public func addPairing(_ pairingKey: Data, _ publicKey: Data) {
        
        let wasPaired = isPaired
        pairings[pairingKey] = publicKey
        
        if wasPaired {
            // Update the Bonjour TXT record
            notifyConfigurationChange()
        }
    }
    
    // Remove the pairing in the internal DB and notify the change
    // to update the Bonjour broadcast
    public func removePairing(_ pairingKey: Data) {
        pairings[pairingKey] = nil
        
        if !isPaired {
            // Update the Bonjour TXT record
            notifyConfigurationChange()
        }
    }

    // Characteristing listeners

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
            "c#": "\(configuration.number)",

            // Feature flags (e.g. "0x3" for bits 0 and 1). Required if
            // non-zero. See table:
            // 0x01         1   Supports HAP Pairing. This flag is required for
            //                  all HomeKit accessories.
            // 0x02-0x80    2-8 Reserved.
            //
            // NOTE: On non-certified HAP devices (like this package), we can't
            // set this to 0x01 as clients will send parameters we don't
            // understand.
            "ff": "0",

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
            "sf": (isPaired ? "0" : "1"),

            // Accessory Category Identifier. Required. Indicates the category
            // that best describes the primary function of the accessory. This
            // must have a range of 1-65535. This must take values defined in
            // Table 12-3 (page 254). This must persist across reboots, power
            // cycles, etc.
            "ci": category.rawValue // category identifier
        ]
    }
}
