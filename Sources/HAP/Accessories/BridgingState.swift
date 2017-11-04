extension Accessory {
    open class BridgingState: Accessory {
        public let bridgingState = Service.BridgingState()

        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [bridgingState])
        }
    }
}

public typealias Reachable = Bool
public typealias LinkQuality = Int
public typealias AccessoryIdentifier = String
public typealias Category = Int

extension Service {
    open class BridgingState: Service {
        public let reachable = GenericCharacteristic<Reachable>(type: .reachable, permissions: [.read, .events])
        public let linkQuality = GenericCharacteristic<LinkQuality>(type: .linkQuality, permissions: [.read, .events])
        public let accessoryIdentifier = GenericCharacteristic<AccessoryIdentifier>(type: .accessoryIdentifier, permissions: [.read, .events])
        public let category = GenericCharacteristic<Category>(type: .category, permissions: [.read, .events])

        public init() {
            super.init(type: .bridgingState, characteristics: [reachable, linkQuality, accessoryIdentifier, category])
        }
    }
}
