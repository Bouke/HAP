import Foundation

public extension AnyCharacteristic {
    static func currentTemperature(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Temperature",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .celsius,
        maxLength: Int? = nil,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        minStep: Double? = 0.1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.currentTemperature(
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
    static func currentTemperature(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Temperature",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .celsius,
        maxLength: Int? = nil,
        maxValue: Double? = 100,
        minValue: Double? = 0,
        minStep: Double? = 0.1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Float> {
        GenericCharacteristic<Float>(
            type: .currentTemperature,
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
