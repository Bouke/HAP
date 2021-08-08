import Foundation

public extension AnyCharacteristic {
    static func characteristicValueTransitionControl(
        _ value: Data = Data(),
        permissions: [CharacteristicPermission] = [.read, .write],
        description: String? = "Characteristic Value Transition Control",
        format: CharacteristicFormat? = .tlv8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.characteristicValueTransitionControl(
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
    static func characteristicValueTransitionControl(
        _ value: Data = Data(),
        permissions: [CharacteristicPermission] = [.read, .write],
        description: String? = "Characteristic Value Transition Control",
        format: CharacteristicFormat? = .tlv8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = nil,
        minValue: Double? = nil,
        minStep: Double? = nil,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Data> {
        GenericCharacteristic<Data>(
            type: .characteristicValueTransitionControl,
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
