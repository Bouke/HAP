public enum ServiceType: String {
    case info = "3E"
    case lightbulb = "43"
    case `switch` = "49"
    case thermostat = "4A"
}

public class Service {
    weak var accessory: Accessory?

    var id: Int
    public let type: ServiceType
    let characteristics: [AnyCharacteristic]

    init(id: Int = 0, type: ServiceType, characteristics: [AnyCharacteristic]) {
        self.id = id
        self.type = type
        self.characteristics = characteristics
    }
}

extension Service: JSONSerializable {
    public func serialized() -> [String : AnyObject] {
        return [
            "iid": id as AnyObject,
            "type": type.rawValue as AnyObject,
            "characteristics": characteristics.map { $0.serialized() } as AnyObject
        ]
    }
}
