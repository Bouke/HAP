extension Accessory {
    open class LockMechanism: Accessory {
        public let lockMechanism = Service.LockMechanism()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .doorLock, services: [lockMechanism] + additionalServices)
        }
    }
}

public enum LockCurrentState: Int, CharacteristicValueType {
    case unsecured = 0, secured, jammed, unknown
}

public enum LockTargetState: Int, CharacteristicValueType {
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
