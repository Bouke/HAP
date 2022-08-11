import Foundation

extension Service {
    open class Doorbell: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            programmableSwitchEvent = getOrCreateAppend(
                type: .programmableSwitchEvent,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.programmableSwitchEvent() })
            brightness = get(type: .brightness, characteristics: unwrapped)
            mute = get(type: .mute, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            volume = get(type: .volume, characteristics: unwrapped)
            super.init(type: .doorbell, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let programmableSwitchEvent: GenericCharacteristic<UInt8>

        // MARK: - Optional Characteristics
        public let brightness: GenericCharacteristic<Int>?
        public let mute: GenericCharacteristic<Bool>?
        public let name: GenericCharacteristic<String>?
        public let volume: GenericCharacteristic<UInt8>?
    }
}
