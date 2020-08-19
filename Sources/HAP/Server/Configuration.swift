import Foundation
import Logging
import Crypto

fileprivate let logger = Logger(label: "hap.device")

typealias PrivateKey = Data

extension Device {

    static internal func generateIdentifier() -> String {
        return (0..<6).map { _ in UInt8.random(in: 0...255) }
            .map { String($0, radix: 16, uppercase: true).padLeft(toLength: 2, withPad: "0") }
            .joined(separator: ":")
    }

    // The device maitains a configuration number during its life time, which
    // persists across restarts of the app.
    internal struct Configuration: Codable {
        let identifier: String
        var setupCode: String
        let setupKey: String
        let publicKey: PublicKey
        let privateKey: PrivateKey

        /// Initializes a new configuration
        init() {
            identifier = Device.generateIdentifier()
            setupCode = SetupCode.generate()
            setupKey = SetupCode.generateSetupKey()

            // todo: use `Curve25519.Signing.PrivateKey` throughout
            let key = Curve25519.Signing.PrivateKey()
            privateKey = key.rawRepresentation
            publicKey = key.publicKey.rawRepresentation
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
            return aidGenerator.next()!
        }

        internal var pairings: [PairingIdentifier: Pairing] = [:]
    }

}
