extension Accessory {
    open class Window: Accessory {
        public let window = Service.Window()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .window, services: [window] + additionalServices)
        }
    }
}

extension Service {
    open class Window: WindowBase {
    }
}
