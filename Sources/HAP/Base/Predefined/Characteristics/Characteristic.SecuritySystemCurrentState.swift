import Foundation

public extension AnyCharacteristic {
    static func securitySystemCurrentState(
        _ value: Enums.SecuritySystemCurrentState = .disarm,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Security System Current State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 4,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.securitySystemCurrentState(
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
    static func securitySystemCurrentState(
        _ value: Enums.SecuritySystemCurrentState = .disarm,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Security System Current State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 4,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.SecuritySystemCurrentState> {
        GenericCharacteristic<Enums.SecuritySystemCurrentState>(
            type: .securitySystemCurrentState,
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
