import Foundation

extension Service {
    open class Doorbell: Service {
        // Required Characteristics
        public let programmableSwitchEvent: GenericCharacteristic<UInt8>

        // Optional Characteristics
        public let brightness: GenericCharacteristic<Int>?
        public let mute: GenericCharacteristic<Bool>?
        public let name: GenericCharacteristic<String>?
        public let operatingStateResponse: GenericCharacteristic<Data>?
        public let volume: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            programmableSwitchEvent = getOrCreateAppend(
                type: .programmableSwitchEvent,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.programmableSwitchEvent() })
            brightness = get(type: .brightness, characteristics: unwrapped)
            mute = get(type: .mute, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            operatingStateResponse = get(type: .operatingStateResponse, characteristics: unwrapped)
            volume = get(type: .volume, characteristics: unwrapped)
            super.init(type: .doorbell, characteristics: unwrapped)
        }
    }
}
