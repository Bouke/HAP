extension Accessory {
    open class Fan: Accessory {
        public let fan = Service.Fan()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .fan, services: [fan] + additionalServices)
        }
    }
}

extension Service {
    public class Fan: FanBase {
    }
}
