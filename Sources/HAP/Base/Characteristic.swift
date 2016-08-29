import Foundation
import class HTTP.Connection

protocol AnyCharacteristic: class, JSONSerializable {
    var iid: Int { get set }
    weak var service: Service? { get set }
    func setValue(withNSObject newValue: NSObject?, fromConnection connection: Connection) throws -> ()
    var valueAsNSObject: NSObject? { get }
}

public enum Characteristic {
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
        case currentPosition = "6D"
        case positionState = "72"
        case targetPosition = "7C"
        case airQuality = "95"
        case batteryLevel = "68"
        case chargingState = "8F"
        case statusLowBattery = "79"
        case configureBridgedAccessoryStatus = "9D"
        case discoverBridgedAccessories = "9E"
        case discoveredBridgedAccessories = "9F"
        case configureBridgedAccessory = "A0"
        case reachable = "63"
        case linkQuality = "9C"
        case accessoryIdentifier = "57"
        case category = "A3"
    }

    public enum Permission: String {
        case read = "pr"
        case write = "pw"
        case events = "ev"

        static let ReadWrite: [Permission] = [.read, .write, .events]
    }

    public enum Format: String {
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

    public enum Unit: String {
        case percentage = "percentage"
        case arcdegrees = "arcdegrees"
        case celcius = "celcius"
        case lux = "lux"
        case seconds = "seconds"
    }

}

open class GenericCharacteristic<ValueType: NSObjectConvertible>: AnyCharacteristic {
    weak var service: Service?

    var iid: Int
    public let type: Characteristic.`Type`

    internal var _value: ValueType?
    public var value: ValueType? {
        get {
            return _value
        }
        set {
            _value = newValue
            guard let device = service?.accessory?.device else { return }
            device.notify(characteristicListeners: self)
            _ = onValueChange.map { $0(newValue) }
        }
    }
    public var onValueChange: [(ValueType?) -> ()] = []

    let permissions: [Characteristic.Permission]

    let description: String?
    let format: Characteristic.Format?
    let unit: Characteristic.Unit?

    let maxLength: Int?
    let maxValue: NSNumber?
    let minValue: NSNumber?
    let stepValue: NSNumber?

    init(iid: Int = 0, type: Characteristic.`Type`, value: ValueType? = nil, permissions: [Characteristic.Permission] = [.read, .write, .events], description: String? = nil, format: Characteristic.Format? = nil, unit: Characteristic.Unit? = nil, maxLength: Int? = nil, maxValue: NSNumber? = nil, minValue: NSNumber? = nil, stepValue: NSNumber? = nil) {
        self.iid = iid
        self.type = type
        self._value = value
        self.permissions = permissions

        self.description = description
        self.format = format ?? ValueType.format
        self.unit = unit

        self.maxLength = maxLength
        self.maxValue = maxValue
        self.minValue = minValue
        self.stepValue = stepValue
    }

    public func setValue(withNSObject newValue: NSObject?, fromConnection connection: Connection) {
        _value = newValue.flatMap { ValueType(withNSObject: $0) }
        _ = onValueChange.map { $0(_value) }
    }

    public var valueAsNSObject: NSObject? {
        return value?.asNSObject
    }
}

extension GenericCharacteristic: JSONSerializable {
    public func serialized() -> [String : AnyObject] {
        var serialized: [String : AnyObject] = [
            "iid": iid as AnyObject,
            "type": type.rawValue as AnyObject,
            "perms": permissions.map { $0.rawValue } as AnyObject
        ]
        if let value = value { serialized["value"] = value.asNSObject }

        if let description = description { serialized["description"] = description as AnyObject }
        if let format = format { serialized["format"] = format.rawValue as AnyObject }
        if let unit = unit { serialized["unit"] = unit.rawValue as AnyObject }

        if let maxLength = maxLength { serialized["maxLength"] = maxLength as NSNumber }
        if let maxValue = maxValue { serialized["maxValue"] = maxValue }
        if let minValue = minValue { serialized["minValue"] = minValue }
        if let stepValue = stepValue { serialized["stepValue"] = stepValue }

        return serialized
    }
}

extension GenericCharacteristic: Hashable {
    public var hashValue: Int {
        return iid.hashValue
    }
}

extension GenericCharacteristic: Equatable {
    public static func == (lhs: GenericCharacteristic, rhs: GenericCharacteristic) -> Bool {
        return lhs === rhs
    }
}
