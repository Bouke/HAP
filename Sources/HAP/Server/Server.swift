import Foundation
import HTTP
import Logging
import NIO
import NIOHTTP1

#if os(Linux)
    import Dispatch
    import NetService
#endif

fileprivate let logger = Logger(label: "hap.http")

enum ServerError: Error {
    case couldNotBindToPort(Error)
    case couldNotStop(Error)
}

public class Server: NSObject, NetServiceDelegate {
    let device: Device

    let service: NetService

    let group: EventLoopGroup
    let bootstrap: ServerBootstrap
    let ownGroup: Bool

    let channel: Channel

    /// Boot a new Server for the given Device and start advertising.
    /// - Parameters:
    ///   - device: the device to advertise
    ///   - listenPort: (optional) the port to listen on, if 0 a random port will be chosen
    ///     (default: 0)
    ///   - worker: (optional) by default a new `MultiThreadedEventLoopGroup` loop is created
    ///     having the same `numberOfThreads` as the `System.coreCount`, provide your own
    ///     `EventLoopGroup` for more control
    public init(
        device: Device,
        listenPort requestedPort: Int = 0,
        worker: EventLoopGroup? = nil
    ) throws {
        precondition(device.server == nil, "Device already assigned to other Server instance")
        self.device = device

        device.controllerHandler = ControllerHandler()
        device.controllerHandler!.removeSubscriptions = device.removeSubscriberForAllCharacteristics

        let application = ApplicationHandler(responder: root(device: device))

        self.ownGroup = worker == nil
        self.group = worker ?? MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

        bootstrap = ServerBootstrap(group: group)
            // Specify backlog and enable SO_REUSEADDR for the server itself
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

            // Set the handlers that are applied to the accepted child `Channel`s.
            .childChannelInitializer { channel in
                // It's important we use the same handler for all accepted channels.
                // The ControllerHandler is thread-safe!
                channel.pipeline.addHapClientHandlers(application: application, controller: device.controllerHandler!)
            }

            // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator(minimum: 1200, initial: 2056, maximum: 16392))

        logger.debug("binding listening port...")
        do {
            channel = try bootstrap.bind(to: SocketAddress(ipAddress: "::", port: requestedPort)).wait()
        } catch {
            throw ServerError.couldNotBindToPort(error)
        }
        let actualPort = channel.localAddress!.port!
        logger.debug("bound, listening on \(actualPort)")

        /* the server will now be accepting connections */

        service = NetService(domain: "local.",
                             type: "_hap._tcp.",
                             name: device.name,
                             port: Int32(channel.localAddress!.port!))

        super.init()

        service.delegate = self
        device.server = self
        updateDiscoveryRecord()

        service.publish(options: NetService.Options(rawValue: 0))
    }

    /// Stop advertising
    public func stop() throws {
        service.stop()
        channel.close(promise: nil)
        if ownGroup {
            do {
                try group.syncShutdownGracefully()
            } catch {
                throw ServerError.couldNotStop(error)
            }
        }
    }

    /// Update the Accessory configuration on the Bonjour service
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

    public func netService(_ sender: NetService, didNotPublish errorDict: [String: NSNumber]) {
        logger.error("Did not publish Bonjour service: \(errorDict)")
    }
}

extension ChannelPipeline {
    func addHapClientHandlers(application: ChannelHandler, controller: ChannelHandler) -> EventLoopFuture<Void> {
        addHandler(CryptographerHandler()).flatMap {
            self.addHandler(EventHandler()).flatMap {
                self.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
                    self.addHandler(controller).flatMap {
                        self.addHandler(RequestHandler()).flatMap {
                            self.addHandler(UpgradeEventHandler()).flatMap {
                                self.addHandler(application)
                            }
                        }
                    }
                }
            }
        }
    }
}
