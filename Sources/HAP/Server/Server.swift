import Foundation
import HTTPServer
import func Evergreen.getLogger

fileprivate let logger = getLogger("hap")


class Delegate: NSObject, NetServiceDelegate {
    var server: HTTPServer.Server

    init(server: HTTPServer.Server) {
        self.server = server
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        logger.error("didNotPublish: \(errorDict)")
    }

    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        server.accept(inputStream: inputStream, outputStream: outputStream)
    }
}


public class Server {
    public let service: NetService
    internal let delegate: Delegate

    public init(device: Device, port: Int = 0) {
        let application = root(device: device)

        let encryption = EncryptionMiddleware()

        let httpServer = HTTPServer.Server(application: application, streamMiddleware: [encryption])

        delegate = Delegate(server: httpServer)

        service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: Int32(port))

        service.setTXTRecord(NetService.data(fromTXTRecord: device.config))
        service.delegate = delegate
    }

    public func publish() {
        service.publish(options: [.listenForConnections])
        logger.info("Listening on port \(self.service.port)")
    }

    // This is a blocking call.
    // Runs the RunLoop.current, in your own application you
    // usually don't need this and run the runloop yourself.
    public func listen() {
        RunLoop.current.run()
    }
}
