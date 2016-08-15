import Foundation

public class Server {
    let application: Application
    let streamMiddleware: [StreamMiddleware]

    public init(application: Application, streamMiddleware: [StreamMiddleware]) {
        self.application = application
        self.streamMiddleware = streamMiddleware
    }

    var connections: [Connection] = []

    public func accept(inputStream: InputStream, outputStream: NSOutputStream) {
        connections.append(Connection(server: self, inputStream: inputStream, outputStream: outputStream))
        logger.info("New connection, \(self.connections.count) clients")
    }

    func forget(connection: Connection) {
        if let index = connections.index(of: connection) {
            connections.remove(at: index)
        }
        logger.info("Connection closed, \(self.connections.count) clients remaining")
    }
}
