public extension Enums {
    enum CurrentAirQuality: UInt8, CharacteristicValueType {
        case unknown = 0
        case excellent = 1
        case good = 2
        case fair = 3
        case inferior = 4
        case poor = 5
    }
}
