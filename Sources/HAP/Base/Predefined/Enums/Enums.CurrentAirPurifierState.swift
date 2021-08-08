public extension Enums {
    enum CurrentAirPurifierState: UInt8, CharacteristicValueType {
        case inactive = 0
        case idle = 1
        case purifyingAir = 2
    }
}
