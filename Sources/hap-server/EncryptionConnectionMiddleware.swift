import Foundation
import HTTP

class EncryptionConnectionMiddleware: ConnectionMiddleware {
    func handle(incoming: Data, in connection: Connection) -> Data {
        print(self, connection)
        return incoming
    }

    func handle(outgoing: Data, in connection: Connection) -> Data {
        print(self, connection)
        return outgoing
    }
}
