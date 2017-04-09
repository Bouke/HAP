import Foundation

protocol AnyCharacteristic: class, JSONSerializable {
    var iid: Int { get set }
    weak var service: Service? { get set }
    func setValue(_: Any?, fromConnection connection: Server.Connection) throws -> ()
    var valueAsAny: Any? { get }
}

public enum Characteristic {
    public enum `Type`: String {
        case on = "25"
        case brightness = "8"
        case saturation = "2F"
        case hue = "13"
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
        case outletInUse = "26"
        case currentDoorState = "E"
        case targetDoorState = "32"
        case obstructionDetected = "24"
        case lockCurrentState = "1D"
        case lockTargetState = "1E"
        case securitySystemCurrentState = "66"
        case securitySystemTargetState = "67"
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

open class GenericCharacteristic<ValueType: AnyConvertible>: AnyCharacteristic where ValueType: Equatable {
    weak var service: Service?

    var iid: Int
    public let type: Characteristic.`Type`

    internal var _value: ValueType?
    public var value: ValueType? {
        get {
            return _value
        }
        set {
            guard newValue != _value else { return }
            _value = newValue
            guard let device = service?.accessory?.device else { return }
            device.notify(characteristicListeners: self)
        }
    }
    
    // Subscribe a listener to value changes from (remote) clients.
    public var onValueChange: [(ValueType?) -> ()] = []

    let permissions: [Characteristic.Permission]

    let description: String?
    let format: Characteristic.Format?
    let unit: Characteristic.Unit?

    let maxLength: Int?
    let maxValue: Double?
    let minValue: Double?
    let minStep: Double?

    init(iid: Int = 0, type: Characteristic.`Type`, value: ValueType? = nil, permissions: [Characteristic.Permission] = [.read, .write, .events], description: String? = nil, format: Characteristic.Format? = nil, unit: Characteristic.Unit? = nil, maxLength: Int? = nil, maxValue: Double? = nil, minValue: Double? = nil, minStep: Double? = nil) {
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
        self.minStep = minStep
    }

    public func setValue(_ newValue: Any?, fromConnection connection: Server.Connection) {
        let newValue = newValue.flatMap { ValueType(value: $0) }
        guard newValue != _value else { return }
        _value = newValue
        _ = onValueChange.map { $0(_value) }
    }

    public var valueAsAny: Any? {
        return value
    }
}

extension GenericCharacteristic: JSONSerializable {
    public func serialized() -> [String : Any] {
        var serialized: [String : Any] = [
            "iid": iid,
            "type": type.rawValue,
            "perms": permissions.map { $0.rawValue }
        ]
        if let value = value { serialized["value"] = value.asAny }

        if let description = description { serialized["description"] = description }
        if let format = format { serialized["format"] = format.rawValue }
        if let unit = unit { serialized["unit"] = unit.rawValue }

        if let maxLength = maxLength { serialized["maxLength"] = maxLength }
        if let maxValue = maxValue { serialized["maxValue"] = maxValue }
        if let minValue = minValue { serialized["minValue"] = minValue }
        if let minStep = minStep { serialized["minStep"] = minStep }

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
