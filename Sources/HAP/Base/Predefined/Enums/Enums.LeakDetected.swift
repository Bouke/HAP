public extension Enums {
    enum LeakDetected: UInt8, CharacteristicValueType {
        case leakNotDetected = 0
        case leakDetected = 1
    }
}
