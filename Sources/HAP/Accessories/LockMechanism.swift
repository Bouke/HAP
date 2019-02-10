extension Accessory {
    open class LockMechanism: Accessory {
        public let lockMechanism = Service.LockMechanism()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .doorLock, services: [lockMechanism] + additionalServices)
        }
    }
}

extension Service {
    open class LockMechanism: LockMechanismBase {
    }
}
