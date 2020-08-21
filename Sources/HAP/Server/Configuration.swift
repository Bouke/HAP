import Foundation
import Logging
import Crypto

fileprivate let logger = Logger(label: "hap.device")

typealias PrivateKey = Data

extension Device {

    static internal func generateIdentifier() -> String {
        (0..<6).map { _ in UInt8.random(in: 0...255) }
            .map { String($0, radix: 16, uppercase: true).padLeft(toLength: 2, withPad: "0") }
            .joined(separator: ":")
    }

    // The device maitains a configuration number during its life time, which
    // persists across restarts of the app.
    internal struct Configuration: Codable {
        let identifier: String
        var setupCode: String
        let setupKey: String

        let privateKey: Curve25519.Signing.PrivateKey
        var publicKey: Curve25519.Signing.PublicKey {
            privateKey.publicKey
        }

        /// Initializes a new configuration
        init() {
            identifier = Device.generateIdentifier()
            setupCode = SetupCode.generate()
            setupKey = SetupCode.generateSetupKey()
            privateKey = Curve25519.Signing.PrivateKey()
        }

        // HAP Specification 5.4: Current configuration number.
        //
        // Must update when an accessory, service, or characteristic is added or
        // removed on the accessory server.
        // Accessories must increment the config number after a firmware update.
        // This must have a range of 1-4294967295 and wrap to 1 when it overflows.
        // This value must persist across reboots, power cycles, etc.
        internal var number: UInt32 = 0

        // HAP Specification 2.6.1: Instance IDs
        //
        // Instance IDs are numbers with a range of [1, 18446744073709551615]. These
        // numbers are used to uniquely identify HAP accessory objects within an HAP
        // accessory server, or uniquely identify ervices, and characteristics
        // within an HAP accessory object. The instance ID for each object
        // must be unique for the lifetime of the server/ client pairing.
        internal var aidForAccessorySerialNumber = [String: InstanceID]()

        // Hash of the attached accessories, services and characteristics. Used
        // to assert if the current configuration number should be updated after
        // initializing / modifying list of accessories.
        internal var stableHash: Int = 0

        private var aidGenerator = AIDGenerator()

        // The next aid - should be checked against existing devices to ensure it is unique
        internal mutating func nextAID() -> InstanceID {
            aidGenerator.next()!
        }

        internal var pairings: [PairingIdentifier: Pairing] = [:]

        // MARK:- Encodable

        enum CodingKeys: String, CodingKey {
            case aidForAccessorySerialNumber
            case aidGenerator
            case identifier
            case number
            case pairings
            case privateKey
            case setupCode
            case setupKey
            case stableHash
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            aidForAccessorySerialNumber = try values.decode([String: InstanceID].self, forKey: .aidForAccessorySerialNumber)
            aidGenerator = try values.decode(AIDGenerator.self, forKey: .aidGenerator)
            identifier = try values.decode(String.self, forKey: .identifier)
            number = try values.decode(UInt32.self, forKey: .number)
            pairings = try values.decode([PairingIdentifier: Pairing].self, forKey: .pairings)
            let privateKeyBytes = try values.decode(Data.self, forKey: .privateKey)
            privateKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyBytes)
            setupCode = try values.decode(String.self, forKey: .setupCode)
            setupKey = try values.decode(String.self, forKey: .setupKey)
            stableHash = try values.decode(Int.self, forKey: .stableHash)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(aidForAccessorySerialNumber, forKey: .aidForAccessorySerialNumber)
            try container.encode(aidGenerator, forKey: .aidGenerator)
            try container.encode(identifier, forKey: .identifier)
            try container.encode(number, forKey: .number)
            try container.encode(pairings, forKey: .pairings)
            try container.encode(privateKey.rawRepresentation, forKey: .privateKey)
            try container.encode(setupCode, forKey: .setupCode)
            try container.encode(setupKey, forKey: .setupKey)
            try container.encode(stableHash, forKey: .stableHash)
        }
    }

}
