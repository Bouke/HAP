extension Accessory {
    open class AirQualitySensor: Accessory {
        public let airQualitySensor = Service.AirQualitySensor()

        public init(info: Service.Info) {
            super.init(info: info, type: .door, services: [airQualitySensor])
        }
    }
}

public enum AirQuality: Int, CharacteristicValueType {
    case unknown = 0
    case excellent = 1
    case good = 2
    case fair = 3
    case inferior = 4
    case poor = 5
}

extension Service {
    open class AirQualitySensor: AirQualitySensorBase {
    }
}
