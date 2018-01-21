extension Accessory {
    open class SecuritySystem: Accessory {
        public let securitySystem = Service.SecuritySystem()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .securitySystem, services: [securitySystem] + additionalServices)
        }
    }
}

public enum SecuritySystemCurrentState: Int, CharacteristicValueType {
    case stayArm = 0, awayArm, nightArm, disarmed, alarmTriggered
}

public enum SecuritySystemTargetState: Int, CharacteristicValueType {
    case stayArm = 0, awayArm, nightArm, disarmed
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
