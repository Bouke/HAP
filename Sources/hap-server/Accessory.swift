import Foundation
import CLibSodium
import CommonCrypto

func generateIdentifier() -> String {
    return (1...6).map({ _ in String(arc4random() & 255, radix: 16, uppercase: false) }).joined(separator: ":")
}

public class Client {
    let username: String
    let publicKey: Data

    init(username: String, publicKey: Data) {
        self.username = username
        self.publicKey = publicKey
    }
}

public class Accessory {
    public enum `Type` {
        case other
        case bridge
        case fan
        case garageDoorOpener
        case lightbulb
        case doorLock
        case outlet
        case `switch`
        case thermostat
        case sensor
        case alarmSystem
        case door
        case window
        case windowCovering
        case programmableSwitch
        case rangeExtender
    }

    let id: Int
    let type: Type
    let services: [Service]

    init(id: Int, type: Type, services: [Service]) {
        self.id = id
        self.type = type
        self.services = services
    }
}

extension Accessory: JSONSerializable {
    func serialize() -> [String : AnyObject] {
        return [
            "aid": id,
            "services": services.map { $0.serialize() }
        ]
    }
}

public struct Service {
    public enum `Type`: String {
        case info = "3E"
        case `switch` = "49"
        case thermostat = "4A"
    }
    

    let id: Int
    let type: Type
    let characteristics: [Characteristic]
}

extension Service: JSONSerializable {
    func serialize() -> [String : AnyObject] {
        return [
            "iid": id,
            "type": type.rawValue,
            "characteristics": characteristics.map { $0.serialize() }
        ]
    }
}

public class Characteristic {
    public enum `Type`: String {
        case on = "25"
        case currentTemperature = "11"
        case targetTemperature = "35"
        case currentHeatingCoolingState = "F"
        case targetHeatingCoolingState =  "33"
        case temperatureDisplayUnits = "36"
        case identify = "14"
        case manufacturer = "20"
        case model = "21"
        case name = "23"
        case serialNumber = "30"
    }

    enum Permission: String {
        case read = "pr"
        case write = "pw"
        case events = "ev"

        static let ReadWrite: [Permission] = [.read, .write, .events]
    }
    
    enum Format: String {
        case string = "string"
        case bool = "bool"
        case float = "float"
        case uint8 = "uint8"
        case uint16 = "uint16"
        case uint32 = "uint32"
        case int32 = "int32"
        case uint64 = "uint64"
        case data = "data"
        case tlv8 = "tlv8"
    }

    enum Unit: String {
        case percentage = "percentage"
        case arcdegrees = "arcdegrees"
        case celcius = "celcius"
        case lux = "lux"
        case seconds = "seconds"
    }

    let id: Int
    let type: Type
    var value: NSObject?
    let permissions: [Permission]

    let description: String?
    let format: Format?
    let unit: Unit?

    let maxLength: Int?
    let maxValue: NSNumber?
    let minValue: NSNumber?
    let stepValue: NSNumber?

    init(id: Int, type: Type, value: NSObject? = nil, permissions: [Permission], description: String? = nil, format: Format? = nil, unit: Unit? = nil, maxLength: Int? = nil, maxValue: NSNumber? = nil, minValue: NSNumber? = nil, stepValue: NSNumber? = nil) {
        self.id = id
        self.type = type
        self.value = value
        self.permissions = permissions

        self.description = description
        self.format = format
        self.unit = unit

        self.maxLength = maxLength
        self.maxValue = maxValue
        self.minValue = minValue
        self.stepValue = stepValue

    }
}

extension Characteristic: JSONSerializable {
    func serialize() -> [String : AnyObject] {
        var serialized: [String : AnyObject] = [
            "iid": id,
            "type": type.rawValue,
            "perms": permissions.map { $0.rawValue }
        ]
        if let value = value { serialized["value"] = value }

        if let description = description { serialized["description"] = description }
        if let format = format { serialized["format"] = format.rawValue }
        if let unit = unit { serialized["unit"] = unit.rawValue }

        if let maxLength = maxLength { serialized["maxLength"] = maxLength as NSNumber }
        if let maxValue = maxValue { serialized["maxValue"] = maxValue }
        if let minValue = minValue { serialized["minValue"] = minValue }
        if let stepValue = stepValue { serialized["stepValue"] = stepValue }

        return serialized
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
    let accessories: [Accessory]

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
