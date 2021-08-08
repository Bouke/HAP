import Foundation

public extension AnyCharacteristic {
    static func carbonMonoxideDetected(
        _ value: UInt8 = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Carbon monoxide Detected",
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
            PredefinedCharacteristic.carbonMonoxideDetected(
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
    static func carbonMonoxideDetected(
        _ value: UInt8 = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Carbon monoxide Detected",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt8> {
        GenericCharacteristic<UInt8>(
            type: .carbonMonoxideDetected,
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
