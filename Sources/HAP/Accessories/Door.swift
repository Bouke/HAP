extension Accessory {
    open class Door: Accessory {
        public let door = Service.Door()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .door, services: [door] + additionalServices)
        }
    }
}

extension Service {
    open class Door: DoorBase {
    }
}
