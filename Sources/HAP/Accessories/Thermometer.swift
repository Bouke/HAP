extension Accessory {
    open class Thermometer: Accessory {
        public let temperatureSensor = Service.TemperatureSensor()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .sensor, services: [temperatureSensor] + additionalServices)
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
