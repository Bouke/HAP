extension Accessory {
    public class Thermostat: Accessory {
        public let thermostat = Service.Thermostat()

        public init(info: Service.Info) {
            super.init(info: info, type: .thermostat, services: [thermostat])
        }
    }
}

public enum CurrentHeatingCoolingState: Int, NSObjectConvertible {
    case off = 0, heat, cool
}

public enum TargetHeatingCoolingState: Int, NSObjectConvertible {
    case off = 0, heat, cool, auto
}

public typealias CurrentTemperature = Float
public typealias TargetTemperature = Float

public enum TemperatureDisplayUnits: Int, NSObjectConvertible {
    case celcius = 0, fahrenheit
}

extension Service {
    public class Thermostat: Service {
        let currentHeatingCoolingState = GenericCharacteristic<CurrentHeatingCoolingState>(type: .currentHeatingCoolingState, value: .off, permissions: [.read, .events])
        let targetHeatingCoolingState = GenericCharacteristic<TargetHeatingCoolingState>(type: .targetHeatingCoolingState, value: .off)
        let currentTemperature = GenericCharacteristic<CurrentTemperature>(type: .currentTemperature, value: 0, permissions: [.read, .events], maxValue: 100, minValue: -100)
        let targetTemperature = GenericCharacteristic<TargetTemperature>(type: .targetTemperature, value: 20, maxValue: 30, minValue: 0, minStep: 0.1)
        let temperatureDisplayUnits = GenericCharacteristic<TemperatureDisplayUnits>(type: .temperatureDisplayUnits, value: .celcius, permissions: [.read, .events])
        
        public init() {
            super.init(type: .thermostat, characteristics: [currentHeatingCoolingState, targetHeatingCoolingState, currentTemperature, targetTemperature, temperatureDisplayUnits])
        }
    }
}
