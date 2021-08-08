import Foundation

public extension AnyCharacteristic {
    static func hue(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Hue",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .arcdegrees,
        maxLength: Int? = nil,
        maxValue: Double? = 360,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.hue(
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
    static func hue(
        _ value: Float = 0,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Hue",
        format: CharacteristicFormat? = .float,
        unit: CharacteristicUnit? = .arcdegrees,
        maxLength: Int? = nil,
        maxValue: Double? = 360,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Float> {
        GenericCharacteristic<Float>(
            type: .hue,
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
