extension Accessory {
    open class BatteryService: Accessory {
        public let batteryService = Service.BatteryService()

        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [batteryService])
        }
    }
}

public typealias BatteryLevel = Int

public enum ChargingState: Int, CharacteristicValueType {
    case notCharging = 0, charging
}

public enum StatusLowBattery: Int, CharacteristicValueType {
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
