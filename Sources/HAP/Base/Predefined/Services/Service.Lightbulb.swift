import Foundation

extension Service {
    open class Lightbulb: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            powerState = getOrCreateAppend(
                type: .powerState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.powerState() })
            brightness = get(type: .brightness, characteristics: unwrapped)
            colorTemperature = get(type: .colorTemperature, characteristics: unwrapped)
            hue = get(type: .hue, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            saturation = get(type: .saturation, characteristics: unwrapped)
            super.init(type: .lightbulb, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let powerState: GenericCharacteristic<Bool>

        // MARK: - Optional Characteristics
        public let brightness: GenericCharacteristic<Int>?
        public let colorTemperature: GenericCharacteristic<Int>?
        public let hue: GenericCharacteristic<Float>?
        public let name: GenericCharacteristic<String>?
        public let saturation: GenericCharacteristic<Float>?
    }
}
