public typealias Revision = String

extension Service {
    public class Info: InfoBase {

        public init(name: String,
                    serialNumber: String,
                    manufacturer: String = "unknown",
                    model: String = "unknown",
                    firmwareRevision: Revision = "1") {
            super.init(characteristics: [
                .name(name),
                .serialNumber(serialNumber),
                .manufacturer(manufacturer),
                .model(model),
                .firmwareRevision(firmwareRevision)
            ])
        }

        open override func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                                             didChangeValue newValue: T?) {
            if characteristic === identify {
                if let accessory = accessory {
                    accessory.device?.delegate?.didRequestIdentificationOf(accessory)
                }
            }
            super.characteristic(characteristic, didChangeValue: newValue)
        }
    }
}
