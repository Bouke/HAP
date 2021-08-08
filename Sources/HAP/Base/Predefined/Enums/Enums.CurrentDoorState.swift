public extension Enums {
    enum CurrentDoorState: UInt8, CharacteristicValueType {
        case open = 0
        case closed = 1
        case opening = 2
        case closing = 3
        case stopped = 4
    }
}
