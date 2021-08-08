import Foundation

public extension AnyCharacteristic {
    static func currentLightLevel(
        _ value: Float = 0.0001,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Light Level",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .lux,
        maxLength: Int? = nil,
        maxValue: Double? = 100000,
        minValue: Double? = 0.0001,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.currentLightLevel(
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
    static func currentLightLevel(
        _ value: Float = 0.0001,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Light Level",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .lux,
        maxLength: Int? = nil,
        maxValue: Double? = 100000,
        minValue: Double? = 0.0001,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Float> {
        GenericCharacteristic<Float>(
            type: .currentLightLevel,
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
