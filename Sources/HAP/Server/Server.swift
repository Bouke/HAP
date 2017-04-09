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
        var context = [String: Any]()
        func listen(socket: Socket, queue: DispatchQueue, application: @escaping Application) {
            let httpParser = HTTPParser(isRequest: true)
            var cryptographer: Cryptographer? = nil
            let request = HTTPServerRequest(socket: socket, httpParser: httpParser)
            let dateFormatter = { () -> DateFormatter in
                let f = DateFormatter()
                f.timeZone = TimeZone(identifier: "GMT")
                f.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss zzz"
                f.locale = Locale(identifier: "en_US")
                return f
            }()
            queue.async {
                while !socket.remoteConnectionClosed {
                    var readBuffer = Data()
                    _ = try! socket.read(into: &readBuffer)
                    if let cryptographer = cryptographer {
                        readBuffer = try! cryptographer.decrypt(readBuffer)
                    }
                    _ = readBuffer.withUnsafeBytes {
                        httpParser.execute($0, length: readBuffer.count)
                    }

                    guard httpParser.completed else {
                        break
                    }

                    request.parsingCompleted()
                    var response: Response! = nil
                    DispatchQueue.main.sync {
                        response = application(self, request)
                    }
                    response?.headers["Date"] = dateFormatter.string(from: Date())

                    var writeBuffer = response.serialized()
                    if let cryptographer = cryptographer {
                        writeBuffer = try! cryptographer.encrypt(writeBuffer)
                    }
                    if let response = response as? UpgradeResponse {
                        cryptographer = response.cryptographer
                        // todo?: override response
                    }
                    try! socket.write(from: writeBuffer)
                    httpParser.reset()
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
        #if os(macOS)
            let record = device.config.dictionary(key: { $0.key }, value: { $0.value.data(using: .utf8)! })
            service.setTXTRecord(NetService.data(fromTXTRecord: record))
        #elseif os(Linux)
            service.setTXTRecord(device.config)
        #endif

        super.init()
        service.delegate = self
    }
    
    public func start() {
        service.publish()
        logger.info("Listening on port \(self.socket.listeningPort)")
        
        queue.async {
            while self.socket.isListening {
                let client = try! self.socket.acceptClientConnection()
                DispatchQueue.main.async {
                    _ = Connection().listen(socket: client, queue: self.queue, application: self.application)
                }
            }
        }
        
    }
    
    public func stop() {
        service.stop()
        socket.close()
    }
    
    
    #if os(macOS)
        // MARK: Using Network Services
        public func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
            logger.error("didNotPublish: \(errorDict)")
        }
    #elseif os(Linux)
        // MARK: Using Network Services
        public func netServiceWillPublish(_ sender: NetService) { }
        
        public func netServiceDidPublish(_ sender: NetService) { }
        
        public func netService(_ sender: NetService,
                               didNotPublish error: Swift.Error) {
            logger.error("didNotPublish: \(error)")
        }
        
        public func netServiceDidStop(_ sender: NetService) { }
        
        // MARK: Accepting Connections
        public func netService(_ sender: NetService,
                               didAcceptConnectionWith socket: Socket) {  }
    #endif
}
