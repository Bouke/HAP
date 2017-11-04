extension Accessory {
    open class Outlet: Accessory {
        public let outlet = Service.Outlet()

        public init(info: Service.Info) {
            super.init(info: info, type: .outlet, services: [outlet])
        }
    }
}

extension Service {
    open class Outlet: Service {
        public let on = GenericCharacteristic<Bool>(type: .on, value: false)
        public let inUse = GenericCharacteristic<Bool>(type: .outletInUse, value: true, permissions: [.read, .events])

        public init() {
            super.init(type: .outlet, characteristics: [on, inUse])
        }
    }
}
