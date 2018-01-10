extension Accessory {
    open class Fan: Accessory {
        public let fan = Service.Fan()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .fan, services: [fan] + additionalServices)
        }
    }
}

extension Service {
    public class Fan: Service {
        open let on = GenericCharacteristic<On>(type: .on, value: false)

        public init() {
            super.init(type: .fan, characteristics: [on])
        }
    }
}
