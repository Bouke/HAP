//extension Accessory {
//    public class BatteryService: Accessory {
//        public let batteryService = Service.BatteryService()
//
//        public init(aid: Int) {
//            super.init(aid: aid, type: .airQuality, services: [batteryService])
//        }
//    }
//}

public typealias BatteryLevel = Int

public enum ChargingState: Int, NSObjectConvertible {
    case notCharging = 0, charging
}

public enum StatusLowBattery: Int, NSObjectConvertible {
    case batteryLevelNormal = 0, batteryLevelLow
}

extension Service {
    open class BatteryService: Service {
        public let batteryLevel = GenericCharacteristic<BatteryLevel>(type: .batteryLevel, permissions: [.read, .events])
        public let chargingState = GenericCharacteristic<ChargingState>(type: .chargingState, permissions: [.read, .events])
        public let statusLowBattery = GenericCharacteristic<StatusLowBattery>(type: .statusLowBattery, permissions: [.read, .events])
        
        public init() {
            super.init(type: .batteryService, characteristics: [batteryLevel, chargingState, statusLowBattery])
        }
    }
}
