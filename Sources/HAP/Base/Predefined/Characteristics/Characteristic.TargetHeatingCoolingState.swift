import Foundation

public extension AnyCharacteristic {
    static func targetHeatingCoolingState(
        _ value: Enums.TargetHeatingCoolingState = .cool,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Target Heating Cooling State",
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
            PredefinedCharacteristic.targetHeatingCoolingState(
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
    static func targetHeatingCoolingState(
        _ value: Enums.TargetHeatingCoolingState = .cool,
        permissions: [CharacteristicPermission] = [.read, .write, .events],
        description: String? = "Target Heating Cooling State",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 3,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.TargetHeatingCoolingState> {
        GenericCharacteristic<Enums.TargetHeatingCoolingState>(
            type: .targetHeatingCoolingState,
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
