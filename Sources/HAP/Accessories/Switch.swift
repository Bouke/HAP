extension Accessory {
    open class Switch: Accessory {
        public let `switch` = Service.Switch()

        public init(info: Service.Info) {
            super.init(info: info, type: .switch, services: [`switch`])
        }
    }
}

extension Service {
    open class Switch: Service {
        public let on = GenericCharacteristic<On>(type: .on, value: false)

        public init() {
            super.init(type: .switch, characteristics: [on])
        }
    }
}
