extension Accessory {
    public class Lightbulb: Accessory {
        public let lightbulb = Service.Lightbulb()

        public init(aid: Int) {
            super.init(aid: aid, type: .lightbulb, services: [lightbulb])
        }
    }
}

extension Service {
    public class Lightbulb: Service {
        public let on = GenericCharacteristic<Bool>(type: .on)
        public let brightness = GenericCharacteristic<Int>(type: .on)
        public let saturation = GenericCharacteristic<Int>(type: .on)
        public let hue = GenericCharacteristic<Int>(type: .on)

        public init() {
            super.init(type: .lightbulb, characteristics: [on, brightness, saturation, hue])
        }
    }
}
