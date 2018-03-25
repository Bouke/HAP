// swiftlint:disable file_length
import Cryptor
import Foundation
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.device")

// MARK: Pairing State

public enum PairingState {
    case notPaired
    case pairing
    case paired
}

public enum PairingStateError: Error {
    case invalidTransition(from: PairingState, to: PairingState)
}

// MARK: Device class

// swiftlint:disable:next type_body_length
public class Device {
    internal(set) public var name: String {
        didSet {
            notifyConfigurationChange()
        }
    }
    public let isBridge: Bool

    public var setupCode: String {
         return configuration.setupCode
    }

    public private(set) var accessories: [Accessory]

    public weak var delegate: DeviceDelegate?

    let storage: Storage

    weak var server: Server?

    public private(set) var state = PairingState.notPaired {
        didSet {
            logger.info("State change from: \(oldValue) to \(self.state)")
            delegate?.didChangePairingState(from: oldValue, to: state)
        }
    }

    private(set) var characteristicEventListeners: [Box<Characteristic>: WeakObjectSet<Server.Connection>]
    private(set) var configuration: Configuration

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
        setupCode: SetupCode = .random,
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
    ///   - storage: persistence interface for storing pairings, secrets
    ///   - accessory: accessory to publish
    /// - Optional Parameters:
    ///   - setupCode: the code to pair this device, must be in the format XXX-XX-XXX
    ///                if not provided, a code is generated automatically
    convenience public init(
        setupCode: SetupCode = .random,
        storage: Storage,
        accessory: Accessory) {
        self.init(name: accessory.info.name.value!,
                  setupCode: setupCode,
                  storage: storage,
                  accessories: [accessory])
    }

    fileprivate init(
        name: String,
        setupCode: SetupCode = .random,
        storage: Storage,
        accessories: [Accessory]) {

        precondition(setupCode.isValid, "setup code must conform to the format XXX-XX-XXX")
        self.name = name
        self.storage = storage
        isBridge = accessories[0].type == .bridge

        do {
            let configData = try storage.read()
            let decoder = JSONDecoder()
            configuration = try decoder.decode(Configuration.self, from: configData)
        } catch {
            logger.error("Error reading configuration data: \(error), using default configuration instead")
            configuration = Configuration()
        }

        // If the caller has provided a setup code, use that
        switch setupCode {
        case .override(let code):
            configuration.setupCode = code
        case .random:
            break
        }

        // restore state from configuration
        state = configuration.pairings.isEmpty ? .notPaired : .paired

        characteristicEventListeners = [:]

        // 2.6.1.1 Accessory Instance IDs
        // Accessory instance IDs, "aid", are assigned from the same number
        // pool that is global across entire HAP Accessory Server. For example,
        // if the first Accessory object has an instance ID of "1" then no
        // other Accessory object can have an instance ID of "1" within the
        // Accessory Server.

        // Obtain new aid's for any accessories which don't already have one
        self.accessories = [Accessory]()

        // The first accessory must be aid 1
        accessories[0].aid = 1

        addAccessories(accessories)
    }

    private func persistConfig() {
        do {
            let encoder = JSONEncoder()
            let configData = try encoder.encode(configuration)
            try storage.write(configData)
        } catch {
            logger.error("Error encoding configuration data: \(error)")
        }
    }

    public func canAddAccessory(accessory: Accessory) -> Bool {
        // HAP Spec 2.5.3.2 - Maximum 100 accessories
        if !isBridge || accessories.count == 100 {
            return false
        }
        let serialNumber = accessory.serialNumber
        return isUniqueSerialNumber(serialNumber, ignoring: accessory)
    }

    /// Add an array of accessories to this bridge device.
    ///
    /// It is an error to try and add accessories with duplicate serial numbers.
    /// It is an error to try and add accessories to a non-bridge device.
    /// It is an error to try and increase the number of accessories above 99.
    public func addAccessories(_ newAccessories: [Accessory]) {
        let totalNumberOfAccessories = accessories.count + newAccessories.count
        precondition(
            (isBridge && totalNumberOfAccessories <= 100) ||
            (!isBridge && totalNumberOfAccessories == 1),
                     "A maximum of 99 accessories can be added to a bridge")
        let existingSerialNumbers = Set(accessories.map { $0.serialNumber })
        let newSerialNumbers = Set(newAccessories.map { $0.serialNumber })
        precondition(existingSerialNumbers.isDisjoint(with: newSerialNumbers),
                     "Accessories with duplicate serial numbers provided")
        accessories.append(contentsOf: newAccessories)

        // Assign accessory identifiers from possible historical assignment.
        for accessory in newAccessories {
            accessory.device = self
            if accessory.aid == 0 {
                let serialNumber = accessory.serialNumber
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
                // swiftlint:disable:next line_length
                logger.info("Accessory \(accessory.info.name.value ?? "unknown") has a duplicate accessory ID \(accessory.aid), replacing with fresh IID")
                accessory.aid = 0
            }
            if accessory.aid == 0 {
                // Obtain a new aid, which has not already been used
                repeat {
                    accessory.aid = configuration.nextAID()
                } while (!isUniqueAID(accessory.aid, ignoring: accessory))

                // Store the aid in the configuration data.
                let serialNumber = accessory.serialNumber
                configuration.aidForAccessorySerialNumber[serialNumber] = accessory.aid
            }
        }

        // Write configuration data to persist updated aid's and notify listeners
        updatedConfiguration()
    }

    // When a configuration changes
    // - update the configuration number
    // - write the configuration to storage
    // - notify interested parties of the change
    func updatedConfiguration() {
        configuration.number = configuration.number &+ 1
        if configuration.number < 1 {
            configuration.number = 1
        }

        persistConfig()
        notifyConfigurationChange()
    }

    // Notify the server that the config record has changed
    func notifyConfigurationChange() {
        server?.updateDiscoveryRecord()
    }

    public func removeAccessories(_ unwantedAccessories: [Accessory]) {
        if unwantedAccessories.isEmpty {
            return
        }
        for accessory in unwantedAccessories {
            // Ensure the initial accessory is not removed, and that the accessory is in the list
            precondition(accessory.aid != 1, "Cannot remove the Bridge Accessory from a Device")
            guard let index = accessories.index(where: { $0 === accessory }) else {
                preconditionFailure("Removing a non-existant accessory from the Bridge")
            }
            accessories.remove(at: index)
            let serialNumber = accessory.serialNumber
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
        return accessories
            .filter { $0 !== ignoring && $0.serialNumber == serialNumber }
            .isEmpty
    }

    // Check if a given aid is unique amoungst all acessories, except the one being tested
    func isUniqueAID(_ aid: InstanceID, ignoring: Accessory) -> Bool {
        if aid == 0 {
            return false
        }
        return accessories
            .filter { $0 !== ignoring && $0.aid == aid }
            .isEmpty
    }

    // MARK: - Pairing

    func changePairingState(_ newState: PairingState) throws {
        switch (state, newState) {
        case (.pairing, .notPaired), (.notPaired, .pairing):
            state = newState
        case (.pairing, .paired), (.paired, .notPaired):
            state = newState
            // Update the Bonjour TXT record
            notifyConfigurationChange()
        default:
            throw PairingStateError.invalidTransition(from: state, to: newState)
        }
    }

    public var isPaired: Bool {
        return state == .paired
    }

    // Add the pairing to the internal DB and notify the change
    // to update the Bonjour broadcast
    func add(pairing: Pairing) {
        configuration.pairings[pairing.identifier] = pairing
        persistConfig()
        if state == .pairing {
            // swiftlint:disable:next force_try
            try! changePairingState(.paired)
        }
    }

    // Remove the pairing in the internal DB and notify the change
    // to update the Bonjour broadcast
    func remove(pairingWithIdentifier identifier: PairingIdentifier) {
        configuration.pairings[identifier] = nil
        // If the last remaining admin controller pairing is removed, all
        // pairings on the accessory must be removed.
        if configuration.pairings.values.first(where: { $0.role == .admin }) == nil {
            logger.info("Last remaining admin controller pairing is removed, removing all pairings")
            configuration.pairings = [:]
        }
        persistConfig()
        if state == .paired {
            // swiftlint:disable:next force_try
            try! changePairingState(.notPaired)
        }
    }

    func get(pairingWithIdentifier identifier: PairingIdentifier) -> Pairing? {
        return configuration.pairings[identifier]
    }

    // MARK: - Characteristic listeners

    // Add an object which would be notified of changes to Characterisics
    func add(characteristic: Characteristic,
             listener: Server.Connection) {
        if characteristicEventListeners[Box(characteristic)] != nil {
            characteristicEventListeners[Box(characteristic)]!.addObject(object: listener)
        } else {
            characteristicEventListeners[Box(characteristic)] = [listener]
        }
        if let service = characteristic.service, let accessory = service.accessory {
            delegate?.characteristicListenerDidSubscribe(accessory,
                                                         service: service,
                                                         characteristic: AnyCharacteristic(characteristic))
        }
    }

    @discardableResult
    func remove(characteristic: Characteristic,
                listener connection: Server.Connection) -> Server.Connection? {
        guard characteristicEventListeners[Box(characteristic)] != nil else {
            return nil
        }
        let subscriber = characteristicEventListeners[Box(characteristic)]!.remove(connection)
        if subscriber != nil, let service = characteristic.service, let accessory = service.accessory {
            delegate?.characteristicListenerDidUnsubscribe(accessory,
                                                           service: service,
                                                           characteristic: AnyCharacteristic(characteristic))
        }
        return subscriber
    }

    func notifyListeners(of characteristic: Characteristic,
                         exceptListener except: Server.Connection? = nil) {
        // Notify internal listeners (server connections) of changes to a characteristic
        guard let listeners = characteristicEventListeners[Box(characteristic)]?.filter({ $0 != except }),
            !listeners.isEmpty
        else {
            return logger.debug("Value changed, but nobody listening")
        }

        for listener in listeners {
            listener.notificationQueue.append(characteristic: characteristic)
        }
    }

    /// Characteristic's value was changed by controller. Used to notify the delegate.
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        delegate?.characteristic(characteristic,
                                 ofService: service,
                                 ofAccessory: accessory,
                                 didChangeValue: newValue)
    }

    // MARK: - QR code pairing

    // Return a URI which can be displayed as a QR code for quick setup
    // The URI is an encoded form of the setup code and the accessory type, followed by the setup key
    public var setupURI: String {
        let category = accessories[0].type
        let code = UInt(self.setupCode.replacingOccurrences(of: "-", with: ""))!
        let cat = UInt(category.rawValue) ?? UInt(AccessoryType.bridge.rawValue)! // default to a bridge
        let flags = UInt(2) // 2=IP, 4=BLE, 8=IP_WAC
        let b36 = code | flags << 27 | cat << 31
        return "X-HM://" +
            String(b36, radix: 36, uppercase: true).padLeft(toLength: 9, withPad: "0") +
            configuration.setupKey
    }

    // The setup hash broadcast in the MDNS TXT record, which HomeKit uses
    // to match a QR code for automatic setup.
    // The hash is based on the pairing identifier and the four character setup key
    // Both those parameters must persit across restarts
    var setupHash: String {
        let setupHashMaterial = configuration.setupKey + configuration.identifier

        if let sha512 = Digest(using: .sha512).update(string: setupHashMaterial) {
            return Data(bytes: sha512.final()[0..<4]).base64EncodedString()
        } else {
            return ""
        }
    }

    /// QRCode for easy pairing of controllers with this device.
    public var setupQRCode: QRCode {
        return QRCode(from: setupURI)
    }

    var identifier: String {
        return configuration.identifier
    }

    var publicKey: PublicKey {
        return configuration.publicKey
    }

    var privateKey: PrivateKey {
        return configuration.privateKey
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
            "id": identifier,

            // Model name of the accessory (e.g. "Device1,1"). Required.
            "md": name,

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
            "ci": category.rawValue,

            // Hash key used by HomeKit to match a device against its QR code
            // during auto setup. The setupHash should persist across reboots,
            // as its constituents must also persist.
            "sh": self.setupHash
        ]
    }
}
