import Foundation
import CLibSodium
import CommonCrypto
import HTTP

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
    func serialized() -> [String : AnyObject] {
        return [
            "aid": id,
            "services": services.map { $0.serialized() }
        ]
    }
}
