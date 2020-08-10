import Cryptor
import Foundation
import HKDF
import SRP

class Authenticator {

    internal let server: SRP.Server
    private var encryptionKey: HAPSymmetricKey?

    init(username: String,
         salt: Data,
         verificationKey: Data,
         privateKey: Data? = nil) {

        self.server = SRP.Server(username: username,
                                 salt: salt,
                                 verificationKey: verificationKey,
                                 group: .N3072,
                                 algorithm: .sha512)
    }

    /// Returns the challenge. This method is a no-op.
    ///
    /// - Returns: `salt` (s) and `publicKey` (B)
    public func getChallenge() -> (salt: Data, publicKey: Data) {
        return server.getChallenge()
    }

    /// Verify that the client did generate the correct `sessionKey`
    /// from their password and the challenge we provided. We'll generate
    /// the `sessionKey` as well and proof the client we have posession
    /// of the password verifier and thus generated the same `sessionKey`
    /// from that.
    ///
    /// - Parameters:
    ///   - clientPublicKey: client's public key
    ///   - clientKeyProof: client's proof of `sessionKey`
    /// - Returns: our proof of `sessionKey` (H(A|M|K))
    /// - Throws:
    ///    - `AuthenticationFailure.invalidPublicKey` if the client's public
    ///      key is invalid (i.e. B % N is zero).
    ///    - `AuthenticationFailure.keyProofMismatch` if the proof
    ///      doesn't match our own.
    public func verifySession(publicKey clientPublicKey: Data, keyProof clientKeyProof: Data) throws -> Data {
        return try server.verifySession(publicKey: clientPublicKey, keyProof: clientKeyProof)
    }

    public func decrypt(encryptedData: Data, nonce: String) -> Data? {
        self.encryptionKey = HKDF.deriveKey(algorithm: .sha512,
                                            seed: server.sessionKey!,
                                            info: "Pair-Setup-Encrypt-Info".data(using: .utf8)!,
                                            salt: "Pair-Setup-Encrypt-Salt".data(using: .utf8)!,
                                            count: 32)
        guard let encryptionKey = self.encryptionKey else {
            return nil
        }
        return try? ChaCha20Poly1305.decrypt(cipher: encryptedData,
                                             nonce: nonce.data(using: .utf8)!,
                                             key: encryptionKey)
    }

    public func verifyID(username: Data, publicKey: Data, signatureIn: Data, device: Device) -> Data? {
        return self.verifyID(username: username,
                             publicKey: publicKey,
                             signatureIn: signatureIn,
                             deviceID: device.identifier,
                             devicePublicKey: device.publicKey,
                             devicePrivateKey: device.privateKey)
    }

    // swiftlint:disable:next function_parameter_count multiline_parameters
    internal func verifyID(username: Data, publicKey: Data, signatureIn: Data,
                           deviceID: String, devicePublicKey: Data, devicePrivateKey: Data) -> Data? {
        let hashIn = HKDF.deriveKey(algorithm: .sha512,
                                    seed: server.sessionKey!,
                                    info: "Pair-Setup-Controller-Sign-Info".data(using: .utf8)!,
                                    salt: "Pair-Setup-Controller-Sign-Salt".data(using: .utf8)!,
                                    count: 32).data +
            username +
        publicKey

        do {
            try Ed25519.verify(publicKey: publicKey, message: hashIn, signature: signatureIn)
        } catch {
            return nil
        }

        let hashOut = HKDF.deriveKey(algorithm: .sha512,
                                     seed: server.sessionKey!,
                                     info: "Pair-Setup-Accessory-Sign-Info".data(using: .utf8)!,
                                     salt: "Pair-Setup-Accessory-Sign-Salt".data(using: .utf8)!,
                                     count: 32).data +
            deviceID.data(using: .utf8)! +
            devicePublicKey

        return try? Ed25519.sign(privateKey: devicePrivateKey, message: hashOut)
    }

    public func encrypt(message: Data, nonce: String) -> Data? {
        guard let encryptionKey = self.encryptionKey else {
            return nil
        }

        return try? ChaCha20Poly1305.encrypt(message: message,
                                             nonce: nonce.data(using: .utf8)!,
                                             key: encryptionKey)
    }

    /// Creates the salted verification key based on a user's username and
    /// password. Only the salt and verification key need to be stored on the
    /// server, there's no need to keep the plain-text password.
    ///
    /// Keep the verification key private, as it can be used to brute-force
    /// the password from.
    ///
    /// - Parameters:
    ///   - username: user's username
    ///   - password: user's password
    ///   - salt: (optional) custom salt value; if providing a salt, make sure to
    ///       provide a good random salt of at least 16 bytes. Default is to
    ///       generate a salt of 16 bytes.
    /// - Returns: salt (s) and verification key (v)
    public static func createSaltedVerificationKey(
        username: String,
        password: String,
        salt: Data? = nil
    )
        -> (salt: Data, verificationKey: Data) {
            return SRP.createSaltedVerificationKey(username: username,
                                                   password: password,
                                                   salt: salt,
                                                   group: .N3072,
                                                   algorithm: .sha512)
    }
}
