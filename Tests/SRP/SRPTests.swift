import XCTest
import CommonCrypto
@testable import SRP

class SRPTests: XCTestCase {
    func test() throws {
        let username = "Pair-Setup"
        let password = "001-02-003"

        /* Create a salt+verification key for the user's password. The salt and
         * key need to be computed at the time the user's password is set and
         * must be stored by the server-side application for use during the
         * authentication process.
         */
        var salt = generateRandomBytes(count: 16)
        let verificationKey = createSaltedVerificationKey(username: username, password: password, salt: salt)

        let server = Server(salt: salt, username: username, verificationKey: verificationKey, secret: generateRandomBytes(count: 32))
        let B = server.computeB()

        /* Begin authentication process */
        // Host -> User: (bytes_s, bytes_B)
        let client = Client(username: username, password: password, salt: salt, B: B)

        // User -> Host (username, A)
        let A = client.computeA()
        server.setA(A)

        // User -> Host: (bytes_M)
        let M = client.M1
        let H_AMK: Data
        do {
            H_AMK = try server.verifySession(clientM1: M)
        } catch Error.authenticationFailed {
            return XCTFail("Client generated invalid M")
        }

        // Host -> User: (HAMK)
        do {
            try client.verifySession(H_AMK: H_AMK)
        } catch Error.authenticationFailed {
            return XCTFail("Server generated invalid H(AMK)")
        }
    }
}
