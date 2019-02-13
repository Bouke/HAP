extension Accessory {
    open class AirQualitySensor: Accessory {
        public let airQualitySensor = Service.AirQualitySensor()

        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [airQualitySensor])
        }
    }
}

extension Service {
    open class AirQualitySensor: AirQualitySensorBase {
    }
}
