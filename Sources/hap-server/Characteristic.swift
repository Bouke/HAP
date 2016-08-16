import Foundation

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
    func serialized() -> [String : AnyObject] {
        var serialized: [String : AnyObject] = [
            "iid": id as AnyObject,
            "type": type.rawValue as AnyObject,
            "perms": permissions.map { $0.rawValue } as AnyObject
        ]
        if let value = value { serialized["value"] = value }

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

extension Characteristic: Hashable {
    public var hashValue: Int {
        return id
    }
}

extension Characteristic: Equatable {
    public static func == (lhs: Characteristic, rhs: Characteristic) -> Bool {
        return lhs === rhs
    }
}
