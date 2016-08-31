extension Accessory {
    public class Lightbulb: Accessory {
        public let lightbulb = Service.Lightbulb()

        public init(info: Service.Info) {
            super.init(info: info, type: .lightbulb, services: [lightbulb])
        }
    }
}

public typealias On = Bool
public typealias Brightness = Int
public typealias Saturation = Int
public typealias Hue = Int

extension Service {
    public class Lightbulb: Service {
        public let on = GenericCharacteristic<On>(type: .on, value: false)
        public let brightness = GenericCharacteristic<Brightness>(type: .brightness, value: 100, unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)
        public let saturation = GenericCharacteristic<Saturation>(type: .saturation, value: 0, unit: .percentage, maxValue: 100, minValue: 0, minStep: 1)
        public let hue = GenericCharacteristic<Hue>(type: .hue, value: 0, unit: .arcdegrees, maxValue: 360, minValue: 0, minStep: 1)

        public init() {
            super.init(type: .lightbulb, characteristics: [on, brightness, saturation, hue])
        }
    }
}
