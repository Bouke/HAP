extension Accessory {
    open class Thermometer: Accessory {
        public let temperatureSensor = Service.TemperatureSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [temperatureSensor] + additionalServices)
        }
    }
}
