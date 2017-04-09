//extension Accessory {
//    public class AirQualitySensor: Accessory {
//        public let airQualitySensor = Service.AirQualitySensor()
//
//        public init(aid: Int) {
//            super.init(aid: aid, type: .airQuality, services: [airQualitySensor])
//        }
//    }
//}

public enum AirQuality: Int, AnyConvertible {
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
