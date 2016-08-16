public struct Service {
    public enum `Type`: String {
        case info = "3E"
        case lightbulb = "43"
        case `switch` = "49"
        case thermostat = "4A"
    }


    let id: Int
    let type: Type
    let characteristics: [Characteristic]
}

extension Service: JSONSerializable {
    func serialized() -> [String : AnyObject] {
        return [
            "iid": id,
            "type": type.rawValue,
            "characteristics": characteristics.map { $0.serialized() }
        ]
    }
}
