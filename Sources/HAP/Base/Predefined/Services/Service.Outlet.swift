import Foundation

extension Service {
    open class Outlet: Service {
        // Required Characteristics
        public let powerState: GenericCharacteristic<Bool>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let outletInUse: GenericCharacteristic<Bool>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            powerState = getOrCreateAppend(
                type: .powerState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.powerState() })
            name = get(type: .name, characteristics: unwrapped)
            outletInUse = get(type: .outletInUse, characteristics: unwrapped)
            super.init(type: .outlet, characteristics: unwrapped)
        }
    }
}
