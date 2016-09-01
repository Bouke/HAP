extension Accessory {
    open class LockMechanism: Accessory {
        public let lockMechanism = Service.LockMechanism()

        public init(info: Service.Info) {
            super.init(info: info, type: .lockMechanism, services: [lockMechanism])
        }
    }
}

public enum LockCurrentState: Int, NSObjectConvertible {
    case unsecured = 0, secured, jammed, unknown
}

public enum LockTargetState: Int, NSObjectConvertible {
    case unsecured = 0, secured
}

extension Service {
    open class LockMechanism: Service {
        public let lockCurrentState = GenericCharacteristic<LockCurrentState>(type: .lockCurrentState, value: .unsecured, permissions: [.read, .events])
        public let lockTargetState = GenericCharacteristic<LockTargetState>(type: .lockTargetState, value: .unsecured)

        public init() {
            super.init(type: .lockMechanism, characteristics: [lockCurrentState, lockTargetState])
        }
    }
}
