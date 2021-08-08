import Foundation

public extension AnyCharacteristic {
    static func colorTemperature(
        _ value: Int = 140,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Color Temperature",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 500,
        minValue: Double? = 140,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.colorTemperature(
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
    static func colorTemperature(
        _ value: Int = 140,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Color Temperature",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 500,
        minValue: Double? = 140,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Int> {
        GenericCharacteristic<Int>(
            type: .colorTemperature,
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
