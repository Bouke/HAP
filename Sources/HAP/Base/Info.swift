public typealias Revision = String

extension Service {
    public class Info: Service {
        public let identify = GenericCharacteristic<Bool>(type: .identify, permissions: [.write])
        public let manufacturer = GenericCharacteristic<String>(type: .manufacturer, permissions: [.read])
        public let model = GenericCharacteristic<String>(type: .model, permissions: [.read])
        public let name = GenericCharacteristic<String>(type: .name, permissions: [.read])
        public let serialNumber = GenericCharacteristic<String>(type: .serialNumber, permissions: [.read])
        public let firmwareRevision = GenericCharacteristic<Revision>(type: .firmwareRevision, permissions: [.read])

        public init(name: String, manufacturer: String = "undefined", model: String = "undefined", serialNumber: String = "undefined", firmwareRevision: Revision = "1.0.0") {
            super.init(type: .info, characteristics: [identify, self.manufacturer, self.model, self.name, self.serialNumber, self.firmwareRevision])
            self.name.value = name
            self.manufacturer.value = manufacturer
            self.model.value = model
            self.serialNumber.value = serialNumber
            self.firmwareRevision.value = firmwareRevision
            identify.onValueChange.append({ _ in
                guard let accessory = self.accessory else { return }
                _ = accessory.device?.onIdentify.map { $0(accessory) }
            })
        }
    }
}
