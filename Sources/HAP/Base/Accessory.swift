import Foundation
import CommonCrypto
import HTTP

public enum AccessoryType: String {
    case other = "1"
    case bridge = "2"
    case fan = "3"
    case garageDoorOpener = "4"
    case lightbulb = "5"
    case lockMechanism = "6"
    case outlet = "7"
    case `switch` = "8"
    case thermostat = "9"
    case sensor = "10"
    case securitySystem = "11"
    case door = "12"
    case window = "13"
    case windowCovering = "14"
    case programmableSwitch = "15"
    case rangeExtender = "16"
}

open class Accessory {
    public weak var device: Device?
    var aid: Int
    public let type: AccessoryType
    private let info: Service.Info
    internal let services: [Service]

    init(aid: Int = 0, info: Service.Info, type: AccessoryType, services: [Service]) {
        self.aid = aid
        self.type = type
        self.info = info
        self.services = [info] + services

        var iid = 1
        for service in self.services {
            service.iid = iid
            service.accessory = self
            iid += 1
            for characteristic in service.characteristics {
                characteristic.iid = iid
                characteristic.service = service
                iid += 1
            }
        }
    }
}

extension Accessory: JSONSerializable {
    public func serialized() -> [String : AnyObject] {
        return [
            "aid": aid as AnyObject,
            "services": services.map { $0.serialized() } as AnyObject
        ]
    }
}
