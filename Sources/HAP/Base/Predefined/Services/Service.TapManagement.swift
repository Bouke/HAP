import Foundation

extension Service {
    open class TapManagement: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            cryptoHash = getOrCreateAppend(
                type: .cryptoHash,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.cryptoHash() })
            tapType = getOrCreateAppend(
                type: .tapType,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.tapType() })
            token = getOrCreateAppend(
                type: .token,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.token() })
            super.init(type: .tapManagement, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let cryptoHash: GenericCharacteristic<Data?>
        public let tapType: GenericCharacteristic<UInt16>
        public let token: GenericCharacteristic<Data?>

        // MARK: - Optional Characteristics
    }
}
