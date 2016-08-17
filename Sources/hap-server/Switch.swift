extension Accessory {
    class Switch: Accessory {
        let `switch` = Service.Switch()

        init(id: Int) {
            super.init(id: id, type: .switch, services: [`switch`])
        }
    }
}

extension Service {
    class Switch: Service {
        let on = GenericCharacteristic<Bool>(type: .on)

        init() {
            super.init(type: .switch, characteristics: [on])
        }
    }
}
