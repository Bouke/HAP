import Foundation

public extension AnyCharacteristic {
    static func supportedFirmwareUpdateConfiguration(
        _ value: Data = Data(),
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Supported Firmware Update Configuration",
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
            PredefinedCharacteristic.supportedFirmwareUpdateConfiguration(
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
    static func supportedFirmwareUpdateConfiguration(
        _ value: Data = Data(),
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Supported Firmware Update Configuration",
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
            type: .supportedFirmwareUpdateConfiguration,
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
