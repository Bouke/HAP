// swiftlint:disable nesting
extension Accessory {
    open class Lightbulb: Accessory {

        // Three types of Lightbulb
        //  - monochrome    Single color bulb
        //  - color         Color Hue and Saturation can be varied
        //  - colorTemperature(min, max)
        //                  The color temperature in reciprical microkelvin
        //                  1,000,000/(Kelvin). min and max values must
        //                  be within HAP permissible range 50...400
        public enum ColorType {
            case monochrome
            case color
            case colorTemperature(min:Int, max:Int)
        }

        public let lightbulb: Service.Lightbulb

        // Default Lightbulb is a simple monochrome bulb
        public init(info: Service.Info,
                    additionalServices: [Service] = [],
                    type: ColorType = .monochrome,
                    isDimmable: Bool = false) {

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

        // Required Characteristics
        public let on = GenericCharacteristic<On>(type: .on, value: false)

        // Optional Characteristics
        // Note temperature is mutually exclusive from hue & saturation
        public let brightness: GenericCharacteristic<Brightness>?
        public let saturation: GenericCharacteristic<Saturation>?
        public let hue: GenericCharacteristic<Hue>?
        public let temperature: GenericCharacteristic<Temperature>?

        public init(type: Accessory.Lightbulb.ColorType, isDimmable: Bool) {
            var characteristics: [Characteristic] = [on]

            if isDimmable {
                brightness = GenericCharacteristic<Brightness>(
                    type: .brightness,
                    value: 100,
                    unit: .percentage,
                    maxValue: 100,
                    minValue: 0,
                    minStep: 1)
                characteristics.append(brightness!)
            } else {
                brightness = nil
            }

            switch type {
            case .color:
                saturation = GenericCharacteristic<Saturation>(
                    type: .saturation,
                    value: 0,
                    unit: .percentage,
                    maxValue: 100,
                    minValue: 0,
                    minStep: 1)
                hue = GenericCharacteristic<Hue>(
                    type: .hue,
                    value: 0,
                    unit: .arcdegrees,
                    maxValue: 360,
                    minValue: 0,
                    minStep: 1)
                characteristics.append(hue!)
                characteristics.append(saturation!)
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
                hue = nil
                saturation = nil

            default:
                hue = nil
                saturation = nil
                temperature = nil
            }
            super.init(type: .lightbulb, characteristics: characteristics)
        }
    }
}
