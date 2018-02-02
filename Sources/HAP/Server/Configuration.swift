import Cryptor
import Foundation
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap.device")

extension Device {
    
    static internal func generateIdentifier() -> String {
        do {
            return Data(bytes: try Random.generate(byteCount: 6))
                .map { String($0, radix: 16, uppercase: true) }
                .joined(separator: ":")
        } catch {
            fatalError("Could not generate identifier: \(error)")
        }
    }

    // Generate a random four character setup key, used in setupURI and setupHash
    static internal func generateSetupKey() -> String {
        return String(arc4random_uniform(1679616), radix:36, uppercase: true)
    }

    typealias PrivateKey = Data

    // The device maitains a configuration number during its life time, which
    // persists across restarts of the app.
    internal struct Configuration: Codable {
        let identifier: String
        let setupCode: String
        let setupKey: String
        let publicKey: PublicKey
        let privateKey: PrivateKey

        /// Initializes a new configuration
        init(setupCode: SetupCode = .automatic) {
            identifier = Device.generateIdentifier()
            self.setupCode = setupCode.getValidCode()
            setupKey = Device.generateSetupKey()
            (publicKey, privateKey) = Ed25519.generateSignKeypair()
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

        private var aidGenerator = AIDGenerator()

        // The next aid - should be checked against existing devices to ensure it is unique
        internal mutating func nextAID() -> InstanceID {
            return aidGenerator.next()!
        }

        internal var pairings: [PairingIdentifier: Pairing] = [:]
    }

}
