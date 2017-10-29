import Socket
import Foundation
import KituraNet
import func Evergreen.getLogger

#if os(Linux)
    import Dispatch
    import NetService
#endif

fileprivate let logger = getLogger("hap.http")


public class Server: NSObject, NetServiceDelegate {

    class NotificationQueue {
        fileprivate let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
        fileprivate let serverQueue = DispatchQueue(label: "hap.server")
        fileprivate var queue = [Characteristic]()
        weak var listener : Connection?
        var nextAllowableNotificationTime = DispatchTime.now()
        
        func addCharacteristic(_ characteristic: Characteristic) {
            concurrentQueue.async(flags: .barrier) {
                self.queue.append(characteristic)
            }
        }
        
        var queueCount : Int {
            var count = 0
            concurrentQueue.sync {
                count = self.queue.count
            }
            return count
        }
        
        func append(characteristic: Characteristic) {
            DispatchQueue.main.async {
                self.addCharacteristic(characteristic)
                if self.queueCount == 1 {
                    
                    /* HAP Specification 5.8 (excerpts)
                     Network-based notifications must be coalesced
                     by the accessory using a delay of no less than 1 second.
                     Excessive or inappropriate notifications may result
                     in the user being notified of a misbehaving
                     accessory and/or termination of the pairing relationship.
                     */
                    
                    self.nextAllowableNotificationTime = max(self.nextAllowableNotificationTime,DispatchTime.now())
                    var sendCount = 0
                    
                    // cannot use DispatchQueue.main since we are using usleep
                    
                    self.serverQueue.asyncAfter(deadline: self.nextAllowableNotificationTime ) {
                        while DispatchTime.now() < self.nextAllowableNotificationTime+1 && self.queueCount > sendCount {
                            sendCount = self.queueCount
                            usleep(1_000)  // 1 ms wait
                        }
                        
                        DispatchQueue.main.async {
                            defer { self.queue.removeAll() }
                            guard let event = Event(valueChangedOfCharacteristics: self.queue) else {
                                return logger.error("Could not create value change event")
                            }
                            let data = event.serialized()
                            logger.info("Value changed, notifying \(String(describing: self.listener?.socket?.remoteHostname)), event: \(data)")
                            self.listener?.writeOutOfBand(data)
                            self.nextAllowableNotificationTime = .now() + 1
                        }
                    }
                }
            }
        }
    }

    public class Connection: NSObject {
        var context = [String: Any]()
        var socket: Socket?
        var cryptographer: Cryptographer? = nil
        var notificationQueue : NotificationQueue

        override init() {
            notificationQueue = NotificationQueue()
            super.init()
            notificationQueue.listener = self
        }

        func listen(socket: Socket, queue: DispatchQueue, application: @escaping Application) {
            self.socket = socket
            let httpParser = HTTPParser(isRequest: true)
            let request = HTTPServerRequest(socket: socket, httpParser: httpParser)
            queue.async {
                while !socket.remoteConnectionClosed {
                    var readBuffer = Data()
                    do {
                        _ = try socket.read(into: &readBuffer)
                        if let cryptographer = self.cryptographer {
                            readBuffer = try cryptographer.decrypt(readBuffer)
                        }
                        _ = readBuffer.withUnsafeBytes {
                            httpParser.execute($0, length: readBuffer.count)
                        }
                    } catch {
                        logger.error("Error while reading from socket", error: error)
                        break
                    }

                    guard httpParser.completed else {
                        break
                    }

                    request.parsingCompleted()
                    var response: Response! = nil
                    DispatchQueue.main.sync {
                        response = application(self, request)
                    }

                    do {
                        var writeBuffer = response.serialized()
                        if let cryptographer = self.cryptographer {
                            writeBuffer = try cryptographer.encrypt(writeBuffer)
                        }
                        if let response = response as? UpgradeResponse {
                            self.cryptographer = response.cryptographer
                            // todo?: override response
                        }
                        try socket.write(from: writeBuffer)
                        httpParser.reset()
                    } catch {
                        logger.error("Error while writing to socket", error: error)
                        break
                    }
                }
                logger.debug("Closed connection to \(socket.remoteHostname)")
                socket.close()
                self.socket = nil
            }
        }
        func writeOutOfBand(_ data: Data) {
            // TODO: resolve race conditions with the read/write loop
            guard let socket = socket else {
                return
            }
            do {
                var writeBuffer = data
                if let cryptographer = cryptographer {
                    writeBuffer = try cryptographer.encrypt(writeBuffer)
                }
                try socket.write(from: writeBuffer)
            } catch {
                logger.error("Error while writing to socket", error: error)
                socket.close()
            }
        }

        var isAuthenticated: Bool {
            return cryptographer != nil
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
                do {
                    let client = try self.socket.acceptClientConnection()
                    logger.info("Accepted connection from \(client.remoteHostname)")
                    DispatchQueue.main.async {
                        _ = Connection().listen(socket: client, queue: self.queue, application: self.application)
                    }
                } catch {
                    logger.error("Could not accept connections for listening socket", error: error)
                    break
                }
            }
            self.stop()
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
