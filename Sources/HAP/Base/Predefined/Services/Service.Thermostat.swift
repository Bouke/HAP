import Foundation

extension Service {
    open class Thermostat: Service {
        // Required Characteristics
        public let currentHeatingCoolingState: GenericCharacteristic<Enums.CurrentHeatingCoolingState>
        public let targetHeatingCoolingState: GenericCharacteristic<Enums.TargetHeatingCoolingState>
        public let currentTemperature: GenericCharacteristic<Float>
        public let targetTemperature: GenericCharacteristic<Float>
        public let temperatureDisplayUnits: GenericCharacteristic<Enums.TemperatureDisplayUnits>

        // Optional Characteristics
        public let name: GenericCharacteristic<String>?
        public let currentRelativeHumidity: GenericCharacteristic<Float>?
        public let targetRelativeHumidity: GenericCharacteristic<Float>?
        public let coolingThresholdTemperature: GenericCharacteristic<Float>?
        public let heatingThresholdTemperature: GenericCharacteristic<Float>?

        public init(characteristics: [AnyCharacteristic] = []) {
            var unwrapped = characteristics.map { $0.wrapped }
            currentHeatingCoolingState = getOrCreateAppend(
                type: .currentHeatingCoolingState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentHeatingCoolingState() })
            targetHeatingCoolingState = getOrCreateAppend(
                type: .targetHeatingCoolingState,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetHeatingCoolingState() })
            currentTemperature = getOrCreateAppend(
                type: .currentTemperature,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.currentTemperature() })
            targetTemperature = getOrCreateAppend(
                type: .targetTemperature,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.targetTemperature() })
            temperatureDisplayUnits = getOrCreateAppend(
                type: .temperatureDisplayUnits,
                characteristics: &unwrapped,
                generator: { PredefinedCharacteristic.temperatureDisplayUnits() })
            name = get(type: .name, characteristics: unwrapped)
            currentRelativeHumidity = get(type: .currentRelativeHumidity, characteristics: unwrapped)
            targetRelativeHumidity = get(type: .targetRelativeHumidity, characteristics: unwrapped)
            coolingThresholdTemperature = get(type: .coolingThresholdTemperature, characteristics: unwrapped)
            heatingThresholdTemperature = get(type: .heatingThresholdTemperature, characteristics: unwrapped)
            super.init(type: .thermostat, characteristics: unwrapped)
        }
    }
}
