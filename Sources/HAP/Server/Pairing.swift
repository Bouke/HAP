import Foundation
import Logging

typealias PairingIdentifier = Data
typealias PublicKey = Data

internal struct Pairing: Codable {
    enum Role: UInt8, Codable {
        case regularUser = 0x00
        case admin = 0x01
    }

    // iOS Device's Pairing Identifier, iOSDevicePairingID
    let identifier: PairingIdentifier

    // iOS Device's Curve25519 public key
    let publicKey: PublicKey

    var role: Role
}
