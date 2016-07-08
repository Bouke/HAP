import Foundation

public class Server: NSObject, StreamDelegate {
    var application: Application

    public init(application: Application) {
        self.application = application
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
