import Foundation

extension Service {
    open class HeaterCooler: Service {
        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            active = getOrCreateAppend(
                type: .active,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.active() })
            currentHeaterCoolerState = getOrCreateAppend(
                type: .currentHeaterCoolerState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentHeaterCoolerState() })
            targetHeaterCoolerState = getOrCreateAppend(
                type: .targetHeaterCoolerState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetHeaterCoolerState() })
            currentTemperature = getOrCreateAppend(
                type: .currentTemperature,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentTemperature() })
            lockPhysicalControls = get(type: .lockPhysicalControls, characteristics: unwrapped)
            name = get(type: .name, characteristics: unwrapped)
            rotationSpeed = get(type: .rotationSpeed, characteristics: unwrapped)
            swingMode = get(type: .swingMode, characteristics: unwrapped)
            coolingThresholdTemperature = get(type: .coolingThresholdTemperature, characteristics: unwrapped)
            heatingThresholdTemperature = get(type: .heatingThresholdTemperature, characteristics: unwrapped)
            temperatureDisplayUnits = get(type: .temperatureDisplayUnits, characteristics: unwrapped)
            super.init(type: .heaterCooler, characteristics: unwrapped)
        }

        // MARK: - Required Characteristics
        public let active: GenericCharacteristic<Enums.Active>
        public let currentHeaterCoolerState: GenericCharacteristic<Enums.CurrentHeaterCoolerState>
        public let targetHeaterCoolerState: GenericCharacteristic<Enums.TargetHeaterCoolerState>
        public let currentTemperature: GenericCharacteristic<Float>

        // MARK: - Optional Characteristics
        public let lockPhysicalControls: GenericCharacteristic<UInt8>?
        public let name: GenericCharacteristic<String>?
        public let rotationSpeed: GenericCharacteristic<Float>?
        public let swingMode: GenericCharacteristic<UInt8>?
        public let coolingThresholdTemperature: GenericCharacteristic<Float>?
        public let heatingThresholdTemperature: GenericCharacteristic<Float>?
        public let temperatureDisplayUnits: GenericCharacteristic<Enums.TemperatureDisplayUnits>?
    }
}
