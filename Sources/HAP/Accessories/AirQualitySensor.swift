extension Accessory {
    open class AirQualitySensor: Accessory {
        public let airQualitySensor = Service.AirQualitySensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .door, services: [airQualitySensor] + additionalServices)
        }
    }
}
