extension Service {
    class Info: Service {
        let identify = GenericCharacteristic<Bool>(type: .identify, permissions: [.write])
        let manufacturer = GenericCharacteristic<String>(type: .manufacturer, permissions: [.read])
        let model = GenericCharacteristic<String>(type: .model, permissions: [.read])
        let name = GenericCharacteristic<String>(type: .name, permissions: [.read])
        let serialNumber = GenericCharacteristic<String>(type: .serialNumber, permissions: [.read])

        init() {
            super.init(type: .info, characteristics: [identify, manufacturer, model, name, serialNumber])
        }
    }
}
