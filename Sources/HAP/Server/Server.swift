import Foundation
import KituraNet
import Socket
import func Evergreen.getLogger

#if os(Linux)
    import Dispatch
    import NetService
#endif

fileprivate let logger = getLogger("hap.http")

public class Server: NSObject, NetServiceDelegate {
    let device: Device
    let application: Application

    let service: NetService

    let listenSocket: Socket
    let socketLockQueue = DispatchQueue(label: "hap.socketLockQueue")

    var continueRunning = true
    var connectedSockets = [Int32: Socket]()

    public init(device: Device, port: Int = 0) throws {
        precondition(device.server == nil, "Device already assigned to other Server instance")
        self.device = device

        application = root(device: device)

        listenSocket = try Socket.create(family: .inet, type: .stream, proto: .tcp)
        try listenSocket.listen(on: port)

        service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: listenSocket.listeningPort)

        super.init()

        service.delegate = self
        device.server = self
        updateDiscoveryRecord()
    }

    /// Publish the Accessory configuration on the Bonjour service
    func updateDiscoveryRecord() {
        #if os(macOS)
            let record = device.config.dictionary(key: { $0.key }, value: { $0.value.data(using: .utf8)! })
            service.setTXTRecord(NetService.data(fromTXTRecord: record))
        #elseif os(Linux)
            service.setTXTRecord(device.config)
        #endif
    }

    public func start() {
        // TODO: make sure can only be started if not started

        continueRunning = true
        service.publish()
        logger.info("Listening on port \(self.listenSocket.listeningPort)")

        let queue = DispatchQueue.global(qos: .userInteractive)
        queue.async { [unowned self] in
            do {
                repeat {
                    let newSocket = try self.listenSocket.acceptClientConnection()
                    logger.info("Accepted connection from \(newSocket.remoteHostname)")
                    self.addNewConnection(socket: newSocket)
                } while self.continueRunning
            } catch {
                logger.error("Could not accept connections for listening socket", error: error)
            }
            self.stop()
        }
    }

    public func stop() {
        service.stop()
        continueRunning = false
        listenSocket.close()

        socketLockQueue.sync { [unowned self] in
            for socket in self.connectedSockets {
                socket.value.close()
            }
            self.connectedSockets = [:]
        }
    }

    func addNewConnection(socket: Socket) {
        socketLockQueue.sync { [unowned self, socket] in
            self.connectedSockets[socket.socketfd] = socket
        }

        let queue = DispatchQueue.global(qos: .userInteractive)

        // Create the run loop work item and dispatch to the default priority global queue...
        queue.async { [unowned self, socket] in
            Connection().listen(socket: socket, application: self.application)

            logger.debug("Closed connection to \(socket.remoteHostname)")
            socket.close()

            self.socketLockQueue.sync { [unowned self, socket] in
                self.connectedSockets[socket.socketfd] = nil
            }
        }
    }

    #if os(macOS)
        // MARK: Using Network Services
        public func netService(_ sender: NetService, didNotPublish errorDict: [String: NSNumber]) {
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
