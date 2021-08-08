import Foundation

extension Service {
    open class Microphone: Service {
        // Required Characteristics
        public let mute: GenericCharacteristic<Bool>

        // Optional Characteristics
        public let volume: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            mute = getOrCreateAppend(
                type: .mute,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.mute() })
            volume = get(type: .volume, characteristics: unwrapped)
            super.init(type: .microphone, characteristics: unwrapped)
        }
    }
}
