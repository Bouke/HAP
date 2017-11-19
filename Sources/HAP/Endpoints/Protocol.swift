import Foundation

enum Protocol {
    enum Value: Codable {
        case number(NSNumber)
        case string(String)

        enum DecodeError: Error {
            case unsupportedValueType
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let number = try? container.decode(Double.self) {
                self = .number(NSNumber(value: number))
            } else if let string = try? container.decode(String.self) {
                self = .string(string)
            } else {
                throw DecodeError.unsupportedValueType
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case let .number(number):
                try container.encode(number.doubleValue)
            case let .string(string):
                try container.encode(string)
            }
        }
    }

    struct Characteristic: Codable {
        var aid: InstanceID
        var iid: InstanceID
        var status: HAPStatusCodes? = nil

        var value: Value? = nil

        var perms: [CharacteristicPermission]? = nil

        var unit: CharacteristicUnit? = nil
        var type: CharacteristicType? = nil
        var maxLen: Int? = nil
        var maxValue: Double? = nil
        var minValue: Double? = nil
        var minStep: Double? = nil

        var ev: Bool? = nil

        public init(aid: InstanceID, iid: InstanceID, value: Value? = nil, status: HAPStatusCodes? = nil) {
            self.aid = aid
            self.iid = iid
            self.status = status
            self.value = value
        }


    }

    struct CharacteristicContainer: Codable {
        var characteristics: [Characteristic]
    }
}
