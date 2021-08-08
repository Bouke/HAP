public extension Enums {
    enum CurrentFanState: UInt8, CharacteristicValueType {
        case inactive = 0
        case idle = 1
        case blowing = 2
    }
}
