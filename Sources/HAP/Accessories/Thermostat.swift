extension Accessory {
    open class Thermostat: Accessory {
        public let thermostat = Service.Thermostat()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .thermostat, services: [thermostat] + additionalServices)
        }
    }
}

extension Service {
    open class Thermostat: ThermostatBase {
    }
}
