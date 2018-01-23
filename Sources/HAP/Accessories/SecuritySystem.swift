extension Accessory {
    open class SecuritySystem: Accessory {
        public let securitySystem = Service.SecuritySystem()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .securitySystem, services: [securitySystem] + additionalServices)
        }
    }
}

public enum SecuritySystemCurrentState: Int, CharacteristicValueType {
    case stayArm = 0
    case awayArm = 1
    case nightArm = 2
    case disarmed = 3
    case alarmTriggered = 4
}

public enum SecuritySystemTargetState: Int, CharacteristicValueType {
    case stayArm = 0
    case awayArm = 1
    case nightArm = 2
    case disarmed = 3
}

extension Service {
    open class SecuritySystem: Service {
        public let securitySystemCurrentState = GenericCharacteristic<SecuritySystemCurrentState>(
            type: .securitySystemCurrentState,
            value: .disarmed,
            permissions: [.read, .events])
        public let securitySystemTargetState = GenericCharacteristic<SecuritySystemTargetState>(
            type: .securitySystemTargetState,
            value: .disarmed)

        public init() {
            super.init(type: .securitySystem, characteristics: [securitySystemCurrentState, securitySystemTargetState])
        }
    }
}
