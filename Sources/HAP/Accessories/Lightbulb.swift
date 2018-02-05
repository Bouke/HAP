// swiftlint:disable nesting
extension Accessory {
    open class Lightbulb: Accessory {

        public enum ColorType {
            case white
            case color
            case colorTemperature(min:Int, max:Int)
        }
        public let lightbulb: Service.Lightbulb

        public init(info: Service.Info,
                    additionalServices: [Service] = [],
                    type: ColorType = .color,
                    isDimmable: Bool = true) {

            lightbulb = Service.Lightbulb(type: type, isDimmable: isDimmable)
            super.init(info: info, type: .lightbulb, services: [lightbulb] + additionalServices)
        }
    }
}

public typealias On = Bool
public typealias Brightness = Int
public typealias Saturation = Int
public typealias Hue = Int
public typealias Temperature = Int

extension Service {
    open class Lightbulb: Service {
        public let on = GenericCharacteristic<On>(type: .on, value: false)
        public let brightness = GenericCharacteristic<Brightness>(
            type: .brightness,
            value: 100,
            unit: .percentage,
            maxValue: 100,
            minValue: 0,
            minStep: 1)
        public let saturation = GenericCharacteristic<Saturation>(
            type: .saturation,
            value: 0,
            unit: .percentage,
            maxValue: 100,
            minValue: 0,
            minStep: 1)
        public let hue = GenericCharacteristic<Hue>(
            type: .hue,
            value: 0,
            unit: .arcdegrees,
            maxValue: 360,
            minValue: 0,
            minStep: 1)
        public let temperature: GenericCharacteristic<Temperature>?

        public init(type: Accessory.Lightbulb.ColorType, isDimmable: Bool) {
            var characteristics: [Characteristic] = [on]
            if isDimmable {
                characteristics.append(brightness)
            }
            switch type {
            case .color:
                characteristics.append(hue)
                characteristics.append(saturation)
                temperature = nil
            case .colorTemperature(let min, let max):
                precondition(min >= 50 && max <= 400,
                             "Maximum range for color temperature is 50...400, \(min)...\(max) is out of bounds")
                temperature = GenericCharacteristic<Temperature>(
                type: .colorTemperature,
                value: max,
                maxValue: Double(max),
                minValue: Double(min),
                minStep: 1)
                characteristics.append(temperature!)
            default:
                temperature = nil
            }
            super.init(type: .lightbulb, characteristics: characteristics)
        }
    }
}
