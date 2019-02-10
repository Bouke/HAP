public typealias Revision = String

extension Service {
    public class Info: InfoBase {

        public init(name: String,
                    serialNumber: String,
                    manufacturer: String = "undefined",
                    model: String = "undefined",
                    firmwareRevision: Revision = "1.0.0") {
            super.init(optionalCharacteristics: [.firmwareRevision])
            self.name.value = name
            self.manufacturer.value = manufacturer
            self.model.value = model
            self.serialNumber.value = serialNumber
            self.firmwareRevision?.value = firmwareRevision
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
