extension Accessory {
    public class Lightbulb: Accessory {
        let `switch` = Service.Lightbulb()

        public init(aid: Int) {
            super.init(aid: aid, type: .lightbulb, services: [`switch`])
        }
    }
}

extension Service {
    public class Lightbulb: Service {
        let on = GenericCharacteristic<Bool>(type: .on)
        let brightness = GenericCharacteristic<Int>(type: .on)
        let saturation = GenericCharacteristic<Int>(type: .on)
        let hue = GenericCharacteristic<Int>(type: .on)

        public init() {
            super.init(type: .lightbulb, characteristics: [on, brightness, saturation, hue])
        }
    }
}
