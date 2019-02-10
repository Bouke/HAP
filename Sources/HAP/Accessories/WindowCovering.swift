extension Accessory {
    open class WindowCovering: Accessory {
        public let windowCovering = Service.WindowCovering()

        public init(info: Service.Info, additionalServices: [Service] = []) {
            super.init(info: info, type: .windowCovering, services: [windowCovering] + additionalServices)
        }
    }
}

extension Service {
    open class WindowCovering: WindowCoveringBase {
    }
}
