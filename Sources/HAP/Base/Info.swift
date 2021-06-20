import NIO

public typealias Revision = String

extension Service.Info {
    public convenience init(name: String,
                            serialNumber: String,
                            manufacturer: String = "unknown",
                            model: String = "unknown",
                            firmwareRevision: Revision = "1") {
        self.init(characteristics: [
            AnyCharacteristic(IdentifyCharacteristic()),
            .name(name),
            .serialNumber(serialNumber),
            .manufacturer(manufacturer),
            .model(model),
            .firmwareRevision(firmwareRevision)
        ])
    }
}

public class IdentifyCharacteristic: GenericCharacteristic<Bool?> {
    init() {
        super.init(type: .identify, permissions: [.write], description: "Identify", format: .bool)
    }

    open override func setValue(_ newValue: Any?, fromChannel channel: Channel?) throws {
        try super.setValue(newValue, fromChannel: channel)

        if let accessory = service?.accessory {
            accessory.device?.delegate?.didRequestIdentificationOf(accessory)
        }
    }
}
