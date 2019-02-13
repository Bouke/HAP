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
            case colorTemperature(min: Double, max: Double)
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

extension Service {
    open class Lightbulb: LightbulbBase {

        public init(type: Accessory.Lightbulb.ColorType, isDimmable: Bool) {
            var characteristics: [AnyCharacteristic] = []

            if isDimmable {
                 characteristics.append(.brightness())
            }

            switch type {
            case .color:
                characteristics.append(.hue())
                characteristics.append(.saturation())
            case .colorTemperature(let min, let max):
                precondition(min >= 50 && max <= 400,
                             "Maximum range for color temperature is 50...400, \(min)...\(max) is out of bounds")
                characteristics.append(.colorTemperature(maxValue: max, minValue: min))
            default:
                break
            }
            super.init(characteristics: characteristics)
        }
    }
}
