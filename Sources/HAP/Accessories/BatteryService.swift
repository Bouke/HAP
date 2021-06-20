extension Accessory {
    open class BatteryService: Accessory {
        public let battery = Service.Battery()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .other, services: [battery] + additionalServices)
        }
    }
}
