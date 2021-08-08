import Foundation

public extension AnyCharacteristic {
    static func remoteKey(
        _ value: Enums.RemoteKey? = nil,
        permissions: [CharacteristicPermission] = [.write],
        description: String? = "Remote Key",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 16,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> AnyCharacteristic {
        AnyCharacteristic(
            PredefinedCharacteristic.remoteKey(
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
    static func remoteKey(
        _ value: Enums.RemoteKey? = nil,
        permissions: [CharacteristicPermission] = [.write],
        description: String? = "Remote Key",
        format: CharacteristicFormat? = .uint8,
        unit: CharacteristicUnit? = nil,
        maxLength: Int? = nil,
        maxValue: Double? = 16,
        minValue: Double? = 0,
        minStep: Double? = 1,
        validValues: [Double] = [],
        validValuesRange: Range<Double>? = nil
    ) -> GenericCharacteristic<Enums.RemoteKey?> {
        GenericCharacteristic<Enums.RemoteKey?>(
            type: .remoteKey,
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
