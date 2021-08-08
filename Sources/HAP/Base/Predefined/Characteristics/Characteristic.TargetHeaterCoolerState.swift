import Foundation

public extension AnyCharacteristic {
    static func targetHeaterCoolerState(
        _ value: Enums.TargetHeaterCoolerState = .auto,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Target Heater-Cooler State",
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
            PredefinedCharacteristic.targetHeaterCoolerState(
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
    static func targetHeaterCoolerState(
        _ value: Enums.TargetHeaterCoolerState = .auto,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Target Heater-Cooler State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 2,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.TargetHeaterCoolerState> {
        GenericCharacteristic<Enums.TargetHeaterCoolerState>(
            type: .targetHeaterCoolerState,
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
