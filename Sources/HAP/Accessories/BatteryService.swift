extension Accessory {
    open class BatteryService: Accessory {
        public let batteryService = Service.BatteryService()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .other, services: [batteryService] + additionalServices)
        }
    }
}

public typealias BatteryLevel = Int

public enum ChargingState: Int, CharacteristicValueType {
    case notCharging = 0
    case charging = 1
}

public enum StatusLowBattery: Int, CharacteristicValueType {
    case batteryLevelNormal = 0
    case batteryLevelLow = 1
}

extension Service {
    open class BatteryService: BatteryBase {
    }
}
