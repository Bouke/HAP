import Foundation

public extension AnyCharacteristic {
    static func targetHumidifierDehumidifierState(
        _ value: Enums.TargetHumidifierDehumidifierState = .auto,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Target Humidifier-Dehumidifier State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 2,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.targetHumidifierDehumidifierState(
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
    static func targetHumidifierDehumidifierState(
        _ value: Enums.TargetHumidifierDehumidifierState = .auto,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Target Humidifier-Dehumidifier State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 2,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.TargetHumidifierDehumidifierState> {
        GenericCharacteristic<Enums.TargetHumidifierDehumidifierState>(
            type: .targetHumidifierDehumidifierState,
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
