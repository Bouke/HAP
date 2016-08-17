public class Service {
    public enum `Type`: String {
        case info = "3E"
        case lightbulb = "43"
        case `switch` = "49"
        case thermostat = "4A"
    }

    var id: Int
    let type: Type
    let characteristics: [AnyCharacteristic]

    init(id: Int = 0, type: Type, characteristics: [AnyCharacteristic]) {
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
