import Foundation

public extension AnyCharacteristic {
    static func threadNodeCapabilities(
        _ value: UInt16 = 0,
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Thread Node Capabilities",
        format: CharacteristicFormat? = .uint16,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 31,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.threadNodeCapabilities(
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
    static func threadNodeCapabilities(
        _ value: UInt16 = 0,
        permissions: [CharacteristicPermission] = [.read],
        description: String? = "Thread Node Capabilities",
        format: CharacteristicFormat? = .uint16,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 31,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<UInt16> {
        GenericCharacteristic<UInt16>(
            type: .threadNodeCapabilities,
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
