extension Accessory {
    open class Thermostat: Accessory {
        public let thermostat = Service.Thermostat()

        public init(info: Service.Info) {
            super.init(info: info, type: .thermostat, services: [thermostat])
        }
    }
}

public enum CurrentHeatingCoolingState: Int, CharacteristicValueType {
    case off = 0, heat, cool
}

public enum TargetHeatingCoolingState: Int, CharacteristicValueType {
    case off = 0, heat, cool, auto
}

public typealias CurrentTemperature = Double
public typealias TargetTemperature = Double

public enum TemperatureDisplayUnits: Int, CharacteristicValueType {
    case celcius = 0, fahrenheit
}

extension Service {
    open class Thermostat: Service {
        public let currentHeatingCoolingState = GenericCharacteristic<CurrentHeatingCoolingState>(type: .currentHeatingCoolingState, value: .off, permissions: [.read, .events])
        public let targetHeatingCoolingState = GenericCharacteristic<TargetHeatingCoolingState>(type: .targetHeatingCoolingState, value: .auto)
        public let currentTemperature = GenericCharacteristic<CurrentTemperature>(type: .currentTemperature, value: 0, permissions: [.read, .events], maxValue: 100, minValue: -100)
        public let targetTemperature = GenericCharacteristic<TargetTemperature>(type: .targetTemperature, value: 20, maxValue: 30, minValue: 0, minStep: 0.1)
        public let temperatureDisplayUnits = GenericCharacteristic<TemperatureDisplayUnits>(type: .temperatureDisplayUnits, value: .celcius, permissions: [.read, .write, .events])

        public init() {
            super.init(type: .thermostat, characteristics: [currentHeatingCoolingState, targetHeatingCoolingState, currentTemperature, targetTemperature, temperatureDisplayUnits])
        }
    }
}
