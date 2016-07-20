import Foundation

public class Server: NSObject, StreamDelegate {
    let application: Application
    let connectionMiddleware: [ConnectionMiddleware]

    public init(application: Application, connectionMiddleware: [ConnectionMiddleware]) {
        self.application = application
        self.connectionMiddleware = connectionMiddleware
    }

    var connections: [Connection] = []

    public func accept(inputStream: InputStream, outputStream: NSOutputStream) {
        connections.append(Connection(server: self, inputStream: inputStream, outputStream: outputStream))
    }

    func forget(connection: Connection) {
        if let index = connections.index(of: connection) {
            connections.remove(at: index)
        }
    }
}
