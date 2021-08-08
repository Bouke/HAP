public extension Enums {
    enum CurrentHumidifierDehumidifierState: UInt8, CharacteristicValueType {
        case inactive = 0
        case idle = 1
        case humidifying = 2
        case dehumidifying = 3
    }
}
