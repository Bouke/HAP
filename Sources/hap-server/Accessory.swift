import Foundation
import CLibSodium
import CommonCrypto
import HTTP

public class Accessory {
    public enum `Type`: String {
        case other = "1"
        case bridge = "2"
        case fan = "3"
        case garageDoorOpener = "4"
        case lightbulb = "5"
        case doorLock = "6"
        case outlet = "7"
        case `switch` = "8"
        case thermostat = "9"
        case sensor = "10"
        case alarmSystem = "11"
        case door = "12"
        case window = "13"
        case windowCovering = "14"
        case programmableSwitch = "15"
        case rangeExtender = "16"
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
