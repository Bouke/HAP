import HTTP

public func runServer(device: Device, port: Int = 0) {
    var controllerHandler = ControllerHandler()
    var applicationHandler = ApplicationHandler(responder: root(device: device))

    let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    let bootstrap = ServerBootstrap(group: group)
        // Specify backlog and enable SO_REUSEADDR for the server itself
        .serverChannelOption(ChannelOptions.backlog, value: 256)
        .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

        // Set the handlers that are applied to the accepted child `Channel`s.
        .childChannelInitializer { channel in
            channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).then {
                // It's important we use the same handler for all accepted channels. The ControllerHandler is thread-safe!
                channel.pipeline.add(handler: controllerHandler).then {
                    channel.pipeline.add(handler: RequestHandler()).then {
                        channel.pipeline.add(handler: applicationHandler)
                    }
                }
            }
        }

        // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
        .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
        .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
        .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
        .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())
    defer {
        try! group.syncShutdownGracefully()
    }
    let channel = try! bootstrap.bind(host: "", port: port).wait()
    /* the server will now be accepting connections */

    print("bound, listening on \(channel.localAddress?.port)")

    try! channel.closeFuture.wait() // wait forever as we never close the Channel
}
