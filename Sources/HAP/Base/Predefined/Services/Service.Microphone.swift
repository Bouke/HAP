import Foundation

extension Service {
    open class Microphone: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            mute = getOrCreateAppend(
                type: .mute,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.mute() })
            volume = get(type: .volume, characteristics: unwrapped)
            super.init(type: .microphone, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let mute: GenericCharacteristic<Bool>

        // MARK: - Optional Characteristics
        public let volume: GenericCharacteristic<UInt8>?
    }
}
