public enum ServiceType: String {
    case info = "3E"
    case lightbulb = "43"
    case `switch` = "49"
    case thermostat = "4A"
    case door = "81"
    case smokeSensor = "87"
    case airQualitySensor = "8D"
    case batteryService = "96"
    case bridgeConfiguration = "A1"
    case bridgingState = "62"
    case humiditySensor = "82"
    case lightSensor = "84"
    case temperatureSensor = "8A"
    case outlet = "47"
    case window = "8B"
    case windowCovering = "8C"
    case fan = "40"
    case garageDoorOpener = "41"
    case lockMechanism = "45"
    case securitySystem = "7E"
}

open class Service {
    weak var accessory: Accessory?

    internal var iid: Int = 0
    public let type: ServiceType
    let characteristics: [Characteristic]

    init(type: ServiceType, characteristics: [Characteristic]) {
        self.type = type
        self.characteristics = characteristics

        // 5.3.2 Service Objects
        // Array of Characteristic objects. Must not be empty. The maximum
        // number of characteristics must not exceed 100, and each
        // characteristic in the array must have a unique type.
        precondition((1...100).contains(characteristics.count),
                     "Number of characteristics must be 1...100")
        precondition(
            Dictionary(grouping: characteristics, by: { $0.type })
                .filter({ $0.value.count > 1 })
                .isEmpty,
            "Service's characteristics must have a unique type")
    }
}

extension Service: JSONSerializable {
    public func serialized() -> [String: JSONValueType] {
        return [
            "iid": iid,
            "type": type.rawValue,
            "characteristics": characteristics.map { $0.serialized() }
        ]
    }
}
