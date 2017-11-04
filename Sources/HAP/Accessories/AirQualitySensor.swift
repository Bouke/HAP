extension Accessory {
    open class AirQualitySensor: Accessory {
        public let airQualitySensor = Service.AirQualitySensor()

        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [airQualitySensor])
        }
    }
}

public enum AirQuality: Int, CharacteristicValueType {
    case unknown = 0, excellent, good, fair, inferior, poor
}

extension Service {
    open class AirQualitySensor: Service {
        public let airQuality = GenericCharacteristic<AirQuality>(type: .airQuality, permissions: [.read, .events])

        public init() {
            super.init(type: .airQualitySensor, characteristics: [airQuality])
        }
    }
}
