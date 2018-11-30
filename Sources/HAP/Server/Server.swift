import Foundation
import KituraNet
import Socket
import func Evergreen.getLogger
import HTTP
import NIO
import NIOHTTP1

#if os(Linux)
    import Dispatch
    import NetService
#endif

fileprivate let logger = getLogger("hap.http")

public class Server: NSObject, NetServiceDelegate {
    let device: Device

    let service: NetService

    let group: EventLoopGroup
    let bootstrap: ServerBootstrap

    let channel: Channel
    let channel6: Channel

    public init(device: Device, port: Int = 0) throws {
        precondition(device.server == nil, "Device already assigned to other Server instance")
        self.device = device

        device.controllerHandler = ControllerHandler()

        let applicationHandler = ApplicationHandler(responder: root(device: device))

        group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        bootstrap = ServerBootstrap(group: group)
            // Specify backlog and enable SO_REUSEADDR for the server itself
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

            // Set the handlers that are applied to the accepted child `Channel`s.
            .childChannelInitializer { channel in
                channel.pipeline.add(handler: CryptographerHandler()).then {
                    channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).then {
                        // It's important we use the same handler for all accepted channels. The ControllerHandler is thread-safe!
                        channel.pipeline.add(handler: device.controllerHandler!).then {
                            channel.pipeline.add(handler: RequestHandler()).then {
                                channel.pipeline.add(handler: UpgradeEventHandler()).then {
                                    channel.pipeline.add(handler: applicationHandler)
                                }
                            }
                        }
                    }
                }
            }

            // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

        channel = try! bootstrap.bind(to: SocketAddress(ipAddress: "0.0.0.0", port: UInt16(port))).wait()
        channel6 = try! bootstrap.bind(to: SocketAddress(ipAddress: "::", port: UInt16(port))).wait()
        /* the server will now be accepting connections */

        print("bound, listening on \(channel.localAddress?.port)")
        print("bound, listening on \(channel6.localAddress?.port)")

        service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: Int32(channel.localAddress!.port!))

        super.init()

        service.delegate = self
        device.server = self
        updateDiscoveryRecord()

        service.publish(options: NetService.Options(rawValue: 0))
    }

    public func wait() {
        try! channel.closeFuture.wait()
        try! channel6.closeFuture.wait()

        defer {
            try! group.syncShutdownGracefully()
        }
    }

    /// Publish the Accessory configuration on the Bonjour service
    func updateDiscoveryRecord() {
        let record = device.config.dictionary(key: { $0.key }, value: { $0.value.data(using: .utf8)! })
        service.setTXTRecord(NetService.data(fromTXTRecord: record))
    }

    public func netServiceDidPublish(_ sender: NetService) {
        // If NetService has renamed the record due to a name collision
        // then update the device and its info service. A host app can
        // watch for changes to the name property on that service
        // if it needs to catch a name collision

        if sender.name != device.name {
            device.name = sender.name
            device.accessories[0].info.name.value = sender.name
            logger.info("Renamed device to \(sender.name)")
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



