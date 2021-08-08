public extension Enums {
    enum ChargingState: UInt8, CharacteristicValueType {
        case notCharging = 0
        case charging = 1
        case notChargeable = 2
    }
}
