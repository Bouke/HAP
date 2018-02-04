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
    let service: NetService
    let socket: Socket
    let queue = DispatchQueue(label: "hap.socket-listener", qos: .utility, attributes: [.concurrent])
    let application: Application

    public init(device: Device, port: Int = 0) throws {
        application = root(device: device)

        socket = try Socket.create(family: .inet, type: .stream, proto: .tcp)
        try socket.listen(on: port)

        service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: socket.listeningPort)

        Server.publishDiscoveryRecordOf(device, to: service)

        super.init()
        service.delegate = self

        device.onConfigurationChange.append({ [weak self] changedDevice in
            if let service = self?.service {
                Server.publishDiscoveryRecordOf(changedDevice, to: service)
            }
        })
    }

    deinit {
        self.stop()
    }

    // Publish the Accessory configuration on the Bonjour service
    private class func publishDiscoveryRecordOf(_ device: Device, to service: NetService) {
        #if os(macOS)
            let record = device.config.dictionary(key: { $0.key }, value: { $0.value.data(using: .utf8)! })
            service.setTXTRecord(NetService.data(fromTXTRecord: record))
        #elseif os(Linux)
            service.setTXTRecord(device.config)
        #endif
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
