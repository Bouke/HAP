import Foundation

public extension AnyCharacteristic {
    static func remainingDuration(
        _ value: UInt32 = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Remaining Duration",
        format: CharacteristicFormat? = .uint32,
        unit: CharacteristicUnit? = .seconds,
        maxLength: Int? = nil,
        maxValue: Double? = 3600,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.remainingDuration(
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
    static func remainingDuration(
        _ value: UInt32 = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Remaining Duration",
        format: CharacteristicFormat? = .uint32,
        unit: CharacteristicUnit? = .seconds,
        maxLength: Int? = nil,
        maxValue: Double? = 3600,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt32> {
        GenericCharacteristic<UInt32>(
            type: .remainingDuration,
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
