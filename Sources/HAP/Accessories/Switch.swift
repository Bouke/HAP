extension Accessory {
    public class Switch: Accessory {
        public let `switch` = Service.Switch()

        public init(aid: Int) {
            super.init(aid: aid, type: .switch, services: [`switch`])
        }
    }
}

extension Service {
    public class Switch: Service {
        public let on = GenericCharacteristic<Bool>(type: .on)

        public init() {
            super.init(type: .switch, characteristics: [on])
        }
    }
}
