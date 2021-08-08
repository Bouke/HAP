import Foundation

extension Service {
    open class Speaker: Service {
        // Required Characteristics
        public let mute: GenericCharacteristic<Bool>

        // Optional Characteristics
        public let active: GenericCharacteristic<Enums.Active>?
        public let volume: GenericCharacteristic<UInt8>?
        public let volumeControlType: GenericCharacteristic<Enums.VolumeControlType>?
        public let volumeSelector: GenericCharacteristic<Enums.VolumeSelector?>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            mute = getOrCreateAppend(
                type: .mute,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.mute() })
            active = get(type: .active, characteristics: unwrapped)
            volume = get(type: .volume, characteristics: unwrapped)
            volumeControlType = get(type: .volumeControlType, characteristics: unwrapped)
            volumeSelector = get(type: .volumeSelector, characteristics: unwrapped)
            super.init(type: .speaker, characteristics: unwrapped)
        }
    }
}
