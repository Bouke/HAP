import Foundation

public extension AnyCharacteristic {
    static func currentTiltAngle(
        _ value: Int = -90,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Tilt Angle",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = .arcdegrees,
        maxLength: Int? = nil,
        maxValue: Double? = 90,
        minValue: Double? = -90,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.currentTiltAngle(
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
    static func currentTiltAngle(
        _ value: Int = -90,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Tilt Angle",
        format: CharacteristicFormat? = .int,
        unit: CharacteristicUnit? = .arcdegrees,
        maxLength: Int? = nil,
        maxValue: Double? = 90,
        minValue: Double? = -90,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Int> {
        GenericCharacteristic<Int>(
            type: .currentTiltAngle,
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
