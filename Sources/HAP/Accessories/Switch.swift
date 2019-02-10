extension Accessory {
    open class Switch: Accessory {
        public let `switch` = Service.Switch()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .switch, services: [`switch`] + additionalServices)
        }
    }
}

extension Service {
    open class Switch: SwitchBase {
    }
}
