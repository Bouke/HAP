public extension Enums {
    enum CurrentHeaterCoolerState: UInt8, CharacteristicValueType {
        case inactive = 0
        case idle = 1
        case heating = 2
        case cooling = 3
    }
}
