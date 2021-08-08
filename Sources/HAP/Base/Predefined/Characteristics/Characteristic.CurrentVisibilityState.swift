import Foundation

public extension AnyCharacteristic {
    static func currentVisibilityState(
        _ value: Enums.CurrentVisibilityState = .shown,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Visibility State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 3,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.currentVisibilityState(
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
    static func currentVisibilityState(
        _ value: Enums.CurrentVisibilityState = .shown,
        permissions: [CharacteristicPermission] = [.read, .events],
        description: String? = "Current Visibility State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 3,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.CurrentVisibilityState> {
        GenericCharacteristic<Enums.CurrentVisibilityState>(
            type: .currentVisibilityState,
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
