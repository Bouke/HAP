extension Accessory {
    class Lightbulb: Accessory {
        let `switch` = Service.Lightbulb()

        init(id: Int) {
            super.init(id: id, type: .lightbulb, services: [`switch`])
        }
    }
}

extension Service {
    class Lightbulb: Service {
        let on = GenericCharacteristic<Bool>(type: .on)
        let brightness = GenericCharacteristic<Int>(type: .on)
        let saturation = GenericCharacteristic<Int>(type: .on)
        let hue = GenericCharacteristic<Int>(type: .on)

        init() {
            super.init(type: .lightbulb, characteristics: [on, brightness, saturation, hue])
        }
    }
}
