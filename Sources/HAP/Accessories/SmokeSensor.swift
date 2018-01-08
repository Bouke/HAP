extension Accessory {
    open class SmokeSensor: Accessory {
        public let smokeSensor = Service.SmokeSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [smokeSensor] + additionalServices)
        }
    }
}

public enum SmokeDetected: Int, CharacteristicValueType {
    case smokeNotDetected = 0, smokeDetected
}

extension Service {
    open class SmokeSensor: Service {
        public let smokeDetected = GenericCharacteristic<SmokeDetected>(type: .currentPosition, permissions: [.read, .events])

        public init() {
            super.init(type: .smokeSensor, characteristics: [smokeDetected])
        }
    }
}
