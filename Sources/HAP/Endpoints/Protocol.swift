// swiftlint:disable nesting
import Foundation

enum Protocol {
    struct GetQuery {
        enum DecodeError: Error {
            case invalidPath
        }
        struct Path {
            var aid: InstanceID
            var iid: InstanceID
            init(_ string: String) throws {
                let components = string.components(separatedBy: ".")
                guard
                    components.count == 2,
                    let aid = InstanceID(components[0]),
                    let iid = InstanceID(components[1])
                    else {
                        throw DecodeError.invalidPath
                }
                self.aid = aid
                self.iid = iid
            }
        }

        var paths: [Path]
        var meta: Bool
        var perms: Bool
        var type: Bool
        var ev: Bool
        init(queryItems: [URLQueryItem]) throws {
            guard let queryIds = queryItems.first(where: { $0.name == "id" })?.value else {
                throw DecodeError.invalidPath
            }
            paths = try queryIds.components(separatedBy: ",").map(Path.init)
            meta = queryItems.first(where: { $0.name == "meta" })?.value == "1"
            perms = queryItems.first(where: { $0.name == "perms" })?.value == "1"
            type = queryItems.first(where: { $0.name == "type" })?.value == "1"
            ev = queryItems.first(where: { $0.name == "ev" })?.value == "1"
        }
    }

    enum Value: Codable {
        case int(Int)
        case double(Double)
        case string(String)
        case bool(Bool)

        enum DecodeError: Error {
            case unsupportedValueType
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let int = try? container.decode(Int.self) {
                self = .int(int)
            } else if let double = try? container.decode(Double.self) {
                self = .double(double)
            } else if let string = try? container.decode(String.self) {
                self = .string(string)
            } else if let bool = try? container.decode(Bool.self) {
                self = .bool(bool)
            } else {
                throw DecodeError.unsupportedValueType
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case let .int(int):
                try container.encode(int)
            case let .double(double):
                try container.encode(double)
            case let .string(string):
                try container.encode(string)
            case let .bool(bool):
                try container.encode(bool)
            }
        }
    }

    struct Characteristic: Codable {
        var aid: InstanceID
        var iid: InstanceID
        var status: HAPStatusCodes?

        var value: Value?

        var perms: [CharacteristicPermission]?

        var unit: CharacteristicUnit?
        var type: CharacteristicType?
        var maxLen: Int?
        var maxValue: Double?
        var minValue: Double?
        var minStep: Double?

        var ev: Bool?

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
