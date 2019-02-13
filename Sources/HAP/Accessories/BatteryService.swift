extension Accessory {
    open class BatteryService: Accessory {
        public let batteryService = Service.BatteryService()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .other, services: [batteryService] + additionalServices)
        }
    }
}

extension Service {
    open class BatteryService: BatteryBase {
    }
}
