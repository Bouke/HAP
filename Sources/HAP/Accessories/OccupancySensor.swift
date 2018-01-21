extension Accessory {
    open class OccupancySensor: Accessory {
        public let occupancySensor = Service.OccupancySensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [occupancySensor] + additionalServices)
        }
    }
}

public enum OccupancyDetected: Int, CharacteristicValueType {
    case notDetected = 0
    case detected = 1
}

extension Service {
    open class OccupancySensor: Service {
        public let occupancyDetected = GenericCharacteristic<OccupancyDetected>(
            type: .occupancyDetected,
            value: .notDetected,
            permissions: [.read, .events])

        public init() {
            super.init(type: .occupancySensor, characteristics: [occupancyDetected])
        }
    }
}
