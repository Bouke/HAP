extension Accessory {
    open class ContactSensor: Accessory {
        public let contactSensor = Service.ContactSensor()
        
        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [contactSensor] + additionalServices)
        }
    }
}

public enum ContactSensorState: Int, CharacteristicValueType {
    case detected = 0, notDetected
}

extension Service {
    open class ContactSensor: Service {
        public let contactSensorState = GenericCharacteristic<ContactSensorState>(type: .contactSensorState, value: .notDetected, permissions: [.read, .events])
        
        public init() {
            super.init(type: .contactSensor, characteristics: [contactSensorState])
        }
    }
}
