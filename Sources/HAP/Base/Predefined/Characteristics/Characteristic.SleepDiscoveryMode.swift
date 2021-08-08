import Foundation

public extension AnyCharacteristic {
    static func sleepDiscoveryMode(
        _ value: Enums.SleepDiscoveryMode = .notdiscoverable,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Sleep Discovery Mode",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.sleepDiscoveryMode(
            value,
            permissions: permissions,
            description: description,
            format: format,
            unit: unit,
            maxLength: maxLength,
            maxValue: maxValue,
            minValue: minValue,
            minStep: minStep,
            validValues: validValues,
            validValuesRange: validValuesRange) as Characteristic)
    }
}

public extension PredefinedCharacteristic {
    static func sleepDiscoveryMode(
        _ value: Enums.SleepDiscoveryMode = .notdiscoverable,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Sleep Discovery Mode",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.SleepDiscoveryMode> {
        GenericCharacteristic<Enums.SleepDiscoveryMode>(
            type: .sleepDiscoveryMode,
            value: value,
            permissions: permissions,
            description: description,
            format: format,
            unit: unit,
            maxLength: maxLength,
            maxValue: maxValue,
            minValue: minValue,
            minStep: minStep,
            validValues: validValues,
            validValuesRange: validValuesRange)
    }
}
