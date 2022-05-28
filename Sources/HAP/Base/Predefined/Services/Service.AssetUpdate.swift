import Foundation

extension Service {
    open class AssetUpdate: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            assetUpdateReadiness = getOrCreateAppend(
                type: .assetUpdateReadiness,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.assetUpdateReadiness() })
            supportedAssetTypes = getOrCreateAppend(
                type: .supportedAssetTypes,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.supportedAssetTypes() })
            super.init(type: .assetUpdate, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let assetUpdateReadiness: GenericCharacteristic<UInt32>
        public let supportedAssetTypes: GenericCharacteristic<UInt32>

        // MARK: - Optional Characteristics
    }
}
