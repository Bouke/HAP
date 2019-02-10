extension Accessory {
    open class SecuritySystem: Accessory {
        public let securitySystem = Service.SecuritySystem()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .securitySystem, services: [securitySystem] + additionalServices)
        }
    }
}

extension Service {
    open class SecuritySystem: SecuritySystemBase {
    }
}
