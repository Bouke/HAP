extension Accessory {
    public class SecuritySystem: Accessory {
        public let securitySystem = Service.SecuritySystem()

        public init(info: Service.Info) {
            super.init(info: info, type: .securitySystem, services: [securitySystem])
        }
    }
}

public enum SecuritySystemCurrentState: Int, NSObjectConvertible {
    case stayArm = 0, awayArm, nightArm, disarmed, alarmTriggered
}

public enum SecuritySystemTargetState: Int, NSObjectConvertible {
    case stayArm = 0, awayArm, nightArm, disarmed
}

extension Service {
    public class SecuritySystem: Service {
        public let securitySystemCurrentState = GenericCharacteristic<SecuritySystemCurrentState>(type: .securitySystemCurrentState, value: .disarmed, permissions: [.read, .events])
        public let securitySystemTargetState = GenericCharacteristic<SecuritySystemTargetState>(type: .securitySystemTargetState, value: .disarmed)

        public init() {
            super.init(type: .securitySystem, characteristics: [securitySystemCurrentState, securitySystemTargetState])
        }
    }
}
