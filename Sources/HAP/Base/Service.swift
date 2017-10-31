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

    var iid: Int
    public let type: ServiceType
    let characteristics: [Characteristic]

    init(iid: Int = 0, type: ServiceType, characteristics: [Characteristic]) {
        self.iid = iid
        self.type = type
        self.characteristics = characteristics
    }
}

extension Service: JSONSerializable {
    public func serialized() -> [String : JSONValueType] {
        return [
            "iid": iid,
            "type": type.rawValue,
            "characteristics": characteristics.map { $0.serialized() }
        ]
    }
}
