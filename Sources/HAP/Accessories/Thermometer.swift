extension Accessory {
    open class Thermometer: Accessory {
        public let temperatureSensor = Service.TemperatureSensor()

        public init(info: Service.Info) {
            super.init(info: info, type: .thermostat, services: [temperatureSensor])
        }
    }
}

extension Service {
    open class TemperatureSensor: Service {
        public let currentTemperature = GenericCharacteristic<CurrentTemperature>(type: .currentTemperature, value: 0, permissions: [.read, .events], maxValue: 100, minValue: -100)

        public init() {
            super.init(type: .temperatureSensor, characteristics: [currentTemperature])
        }
    }
}
