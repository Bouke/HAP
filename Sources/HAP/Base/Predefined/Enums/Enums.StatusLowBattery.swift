public extension Enums {
    enum StatusLowBattery: UInt8, CharacteristicValueType {
        case batteryNormal = 0
        case batteryLow = 1
    }
}
