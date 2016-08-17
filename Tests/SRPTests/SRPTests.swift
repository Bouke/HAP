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
        let (salt, verificationKey) = createSaltedVerificationKey(username: username, password: password)

        let server = Server(salt: salt, username: username, verificationKey: verificationKey, secret: generateRandomBytes(count: 32))

        /* Begin authentication process */
        // Host -> User: (bytes_s, bytes_B)
        let client = Client(username: username, password: password)

        // User -> Host: (bytes_M)
        let M = client.processChallenge(salt: server.salt, B: server.B)

        XCTAssertFalse(server.isAuthenticated)
        XCTAssertFalse(client.isAuthenticated)

        let HAMK: Data
        do {
            HAMK = try server.verifySession(A: client.A, M: M)
        } catch Error.authenticationFailed {
            return XCTFail("Client generated invalid M")
        }

        XCTAssert(server.isAuthenticated)
        XCTAssertFalse(client.isAuthenticated)

        // Host -> User: (HAMK)
        do {
            try client.verifySession(HAMK: HAMK)
        } catch Error.authenticationFailed {
            return XCTFail("Server generated invalid H(AMK)")
        }

        XCTAssert(server.isAuthenticated)
        XCTAssert(client.isAuthenticated)

        guard let K0 = server.sessionKey, let K1 = client.sessionKey else {
            return XCTFail("Session keys not set")
        }
        XCTAssertEqual(K0, K1, "Session keys not equal")
    }
}
