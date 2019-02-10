import Foundation

// TODO: SwiftFoundation in Swift 4.0 cannot encode/decode UInt64,
// which is the data-type we wanted to use here. We can change it back
// to UInt64 once the following commit has made it into a release:
// https://github.com/apple/swift-corelibs-foundation/commit/64b67c91479390776c43a96bd31e4e85f106d5e1
typealias InstanceID = Int

// HAP Specification 2.6.1.1: Accessory Instance IDs
//
// Accessory instance IDs, "aid", are assigned from the same number pool
// that is global across entire HAP Accessory Server. For example, if the
// first Accessory object has an instance ID of "1" then no other Accessory
// object can have an instance ID of "1" within the Accessory Server.
//
// The generator starts at 2, so you have the ability to special-case 1.
struct AIDGenerator: Sequence, IteratorProtocol, Codable {
    internal var lastAID: InstanceID = 1
    mutating func next() -> InstanceID? {
        lastAID = lastAID &+ 1 // Add one and overflow if reach max InstanceID
        if lastAID < 2 {
            lastAID = 2
        }
        return lastAID
    }
}

open class Accessory: JSONSerializable {
    public weak var device: Device?
    internal var aid: InstanceID = 0
    public let type: AccessoryType
    public let info: Service.Info
    internal let services: [Service]

    // An accessory implementation can set this flag to false if a device
    // becomes unreachable for a period. If the accessory has a
    // BridgingState Service, then the reachable property of that Service is set.
    open var reachable = true {
        didSet {
            guard self.reachable == oldValue,
                let characteristic = services
                    .first(where: { $0.type == .bridgingState })?
                    .characteristics
                    .first(where: { $0.type == .reachable }) else {
                        return
            }
            try? characteristic.setValue(self.reachable, fromChannel: nil)
        }
    }

    // An accessory must provide a text identifier, which is guranteed to be
    // unique. The implementation could provide the actual serial number of a
    // device, or a MAC address or some other identifier which is not used on
    // any other accessory.
    //
    // Device will check to ensure the serial numbers of all accessories added
    // to a bridge are are unique.
    //
    // This is used for persistance of HomeKit AID's.
    open var serialNumber: String {
        return info.serialNumber.value!
    }

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
        var idGenerator = (1...InstanceID.max).makeIterator()
        for service in self.services {
            service.iid = idGenerator.next()!
            service.accessory = self
            for characteristic in service.characteristics {
                characteristic.service = service
                characteristic.iid = idGenerator.next()!
            }
        }
    }

    /// Characteristic's value was changed by controller. Used for bubbling up
    /// to the device, which will notify the delegate.
    open func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                                ofService service: Service,
                                didChangeValue newValue: T?) {
        device?.characteristic(characteristic, ofService: service, ofAccessory: self, didChangeValue: newValue)
    }

    public func serialized() -> [String: JSONValueType] {
        return [
            "aid": aid,
            "services": services.map { $0.serialized() }
        ]
    }
}
