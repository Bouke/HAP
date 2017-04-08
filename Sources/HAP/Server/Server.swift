import Socket
import Foundation
import KituraNet
import func Evergreen.getLogger

#if os(Linux)
    import Dispatch
    import NetService
#endif

fileprivate let logger = getLogger("hap")


public class Server: NSObject, NetServiceDelegate {
    public class Connection: NSObject {
        let httpParser = HTTPParser(isRequest: true)
        let socket: Socket
        let queue: DispatchQueue
        let request: HTTPServerRequest
        var context = [String: Any]()
        var cryptographer: Cryptographer? = nil
        public var dateFormatter = { () -> DateFormatter in
            let f = DateFormatter()
            f.timeZone = TimeZone(identifier: "GMT")
            f.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss zzz"
            f.locale = Locale(identifier: "en_US")
            return f
        }()
        init(socket: Socket, queue: DispatchQueue, application: @escaping Application) {
            self.socket = socket
            self.queue = queue
            self.request = HTTPServerRequest(socket: socket, httpParser: httpParser)
            super.init()
            queue.async {
                while !socket.remoteConnectionClosed {
                    var readBuffer = Data()
                    _ = try! socket.read(into: &readBuffer)
                    if let cryptographer = self.cryptographer {
                        readBuffer = try! cryptographer.decrypt(readBuffer)
                    }
                    _ = readBuffer.withUnsafeBytes {
                        self.httpParser.execute($0, length: readBuffer.count)
                    }

                    guard self.httpParser.completed else {
                        break
                    }

                    self.request.parsingCompleted()
                    var response: Response! = nil
                    DispatchQueue.main.sync {
                        response = application(self, self.request)
                    }
                    response?.headers["Date"] = self.dateFormatter.string(from: Date())

                    var writeBuffer = response.serialized()
                    if let cryptographer = self.cryptographer {
                        writeBuffer = try! cryptographer.encrypt(writeBuffer)
                    }
                    if let response = response as? UpgradeResponse {
                        self.cryptographer = response.cryptographer
                        // todo?: override response
                    }
                    try! socket.write(from: writeBuffer)
                    self.httpParser.reset()
                }
                socket.close()
            }
        }
    }
    
    
    let service: NetService
    let socket: Socket
    let queue = DispatchQueue(label: "hap.socket-listener", qos: .utility, attributes: [.concurrent])
    let application: Application

    public init(device: Device, port: Int = 0) throws {
        application = root(device: device)

        socket = try Socket.create(family: .inet, type: .stream, proto: .tcp)
        try socket.listen(on: port)

        service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: socket.listeningPort)
        service.setTXTRecord(NetService.data(fromTXTRecord: device.config))

        super.init()
        service.delegate = self
    }
    
    public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        logger.error("didNotPublish: \(errorDict)")
    }

    public func start() {
        service.publish()
        logger.info("Listening on port \(self.socket.listeningPort)")
        
        queue.async {
            while self.socket.isListening {
                let client = try! self.socket.acceptClientConnection()
                DispatchQueue.main.async {
                    _ = Connection(socket: client, queue: self.queue, application: self.application)
                }
            }
        }
        
    }
    
    public func stop() {
        
    }
}
