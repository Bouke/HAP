import Foundation

public extension AnyCharacteristic {
    static func rotationDirection(
        _ value: Enums.RotationDirection = .counterclockwise,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Rotation Direction",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.rotationDirection(
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
    static func rotationDirection(
        _ value: Enums.RotationDirection = .counterclockwise,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Rotation Direction",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 1,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.RotationDirection> {
        GenericCharacteristic<Enums.RotationDirection>(
            type: .rotationDirection,
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
