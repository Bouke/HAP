import Foundation

//extension Accessory {
//    public class BridgeConfiguration: Accessory {
//        public let bridgeConfiguration = Service.BridgeConfiguration()
//
//        public init(aid: Int) {
//            super.init(aid: aid, type: .airQuality, services: [bridgeConfiguration])
//        }
//    }
//}

public typealias ConfigureBridgedAccessoryStatus = Data

public enum DiscoverBridgedAccessories: Int, NSObjectConvertible {
    case startDiscovery = 0, stopDiscovery
}

public typealias DiscoveredBridgedAccessories = Int

public typealias ConfigureBridgedAccessory = Data


extension Service {
    open class BridgeConfiguration: Service {
        public let configureBridgedAccessoryStatus = GenericCharacteristic<ConfigureBridgedAccessoryStatus>(type: .configureBridgedAccessoryStatus, permissions: [.read, .events])
        public let discoverBridgedAccessories = GenericCharacteristic<DiscoverBridgedAccessories>(type: .discoverBridgedAccessories, permissions: [.read, .events])
        public let discoveredBridgedAccessories = GenericCharacteristic<DiscoveredBridgedAccessories>(type: .discoveredBridgedAccessories, permissions: [.read, .events])
        public let configureBridgedAccessory = GenericCharacteristic<ConfigureBridgedAccessory>(type: .configureBridgedAccessory, permissions: [.read, .events])
        
        public init() {
            super.init(type: .bridgeConfiguration, characteristics: [configureBridgedAccessoryStatus, discoverBridgedAccessories, discoveredBridgedAccessories, configureBridgedAccessory])
        }
    }
}
