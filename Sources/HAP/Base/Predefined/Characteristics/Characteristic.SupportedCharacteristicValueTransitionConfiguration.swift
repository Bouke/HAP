import Foundation

public extension AnyCharacteristic {
    static func supportedCharacteristicValueTransitionConfiguration(
        _ value: Data = Data(),
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Supported Characteristic Value Transition Configuration",
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
            PredefinedCharacteristic.supportedCharacteristicValueTransitionConfiguration(
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
    static func supportedCharacteristicValueTransitionConfiguration(
        _ value: Data = Data(),
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Supported Characteristic Value Transition Configuration",
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
            type: .supportedCharacteristicValueTransitionConfiguration,
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
