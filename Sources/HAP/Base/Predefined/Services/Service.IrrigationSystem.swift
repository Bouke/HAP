import Foundation

extension Service {
    open class IrrigationSystem: Service {
        // Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let programMode: GenericCharacteristic<UInt8>
        public let inUse: GenericCharacteristic<UInt8>

        // Optional Characteristics
        public let remainingDuration: GenericCharacteristic<UInt32>?
        public let name: GenericCharacteristic<String>?
        public let statusFault: GenericCharacteristic<UInt8>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            programMode = getOrCreateAppend(
                type: .programMode,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.programMode() })
            inUse = getOrCreateAppend(
                type: .inUse,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.inUse() })
            remainingDuration = get(type: .remainingDuration, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            statusFault = get(type: .statusFault, characteristics: unwrapped)
            super.init(type: .irrigationSystem, characteristics: unwrapped)
        }
    }
}
