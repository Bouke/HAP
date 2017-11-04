import Foundation

public enum AccessoryType: String, Codable {
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
    internal var aid: Int = 0
    public let type: AccessoryType
    public let info: Service.Info
    internal let services: [Service]

    public init(info: Service.Info, type: AccessoryType, services: [Service]) {
        self.type = type
        self.info = info
        self.services = [info] + services

        // 5.3.1 Accessory Objects
        // Array of Service objects. Must not be empty. The maximum number of
        // services must not exceed 100.
        precondition((1...100).contains(self.services.count),
                     "Number of services should be 1...100")

        // 2.6.1.2 Service and Characteristic Instance IDs
        // Service and Characteristic instance IDs, "iid", are assigned from
        // the same number pool that is unique within each Accessory object.
        // For example, if the first Service object has an instance ID of "1"
        // then no other Service or Characteristic objects can have an instance
        // ID of "1" within the parent Accessory object. The Accessory
        // Information service must have a service instance ID of 1.
        //
        // After a firmware update services and characteristics types that
        // remain unchanged must retain their previous instance ids, newly
        // added services and characteristics must not reuse instance ids from
        // services and characteristics that were removed in the firmware
        // update.
        //
        // TODO: SwiftFoundation in Swift 4.0 cannot encode/decode UInt64,
        // which is the data-type we wanted to use here. We can change it back
        // to UInt64 once the following commit has made it into a release:
        // https://github.com/apple/swift-corelibs-foundation/commit/64b67c91479390776c43a96bd31e4e85f106d5e1
        var idGenerator = (1...Int.max).makeIterator()
        for service in self.services {
            service.iid = idGenerator.next()!
            service.accessory = self
            for characteristic in service.characteristics {
                characteristic.service = service
                characteristic.iid = idGenerator.next()!
            }
        }
    }
}

extension Accessory: JSONSerializable {
    public func serialized() -> [String: JSONValueType] {
        return [
            "aid": aid,
            "services": services.map { $0.serialized() }
        ]
    }
}
