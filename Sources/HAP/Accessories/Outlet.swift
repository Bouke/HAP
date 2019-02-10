extension Accessory {
    open class Outlet: Accessory {
        public let outlet = Service.Outlet()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .outlet, services: [outlet] + additionalServices)
        }
    }
}

extension Service {
    open class Outlet: OutletBase {
    }
}
