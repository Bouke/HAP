import Foundation
import KituraNet
import Socket
import func Evergreen.getLogger

#if os(Linux)
    import Dispatch
#endif

fileprivate let logger = getLogger("hap.http")
private let minimalTimeBetweenNotifications: DispatchTimeInterval = .seconds(1)

extension Server {
    class NotificationQueue {
        private var queue = [InstanceID: Characteristic]()
        fileprivate weak var listener: Connection?
        private var nextAllowableNotificationTime = DispatchTime.now()

        internal func append(characteristic: Characteristic) {
            // Called on MAIN queue (from Device or from characteristics() )

            /* HAP Specification 5.8 (excerpts)
             Network-based notifications must be coalesced
             by the accessory using a delay of no less than 1 second.
             Excessive or inappropriate notifications may result
             in the user being notified of a misbehaving
             accessory and/or termination of the pairing relationship.
             */
            DispatchQueue.main.async {
                self.queue[characteristic.iid] = characteristic
                if DispatchTime.now() >= self.nextAllowableNotificationTime {
                    self.nextAllowableNotificationTime = DispatchTime.now() + minimalTimeBetweenNotifications
                    self.sendQueue()
                } else {
                    logger.debug("queued event for delivery")
                    DispatchQueue.main.asyncAfter(deadline: self.nextAllowableNotificationTime) {
                        self.sendQueue()
                    }
                }
            }
        }

        /// If there are no queued or very recent notifications then send
        /// an empty event to test whether the Connection is still alive.
        /// The socket will be closed if the message cannot be written
        /// to the socket, or if the test causes a simultaneous blocking read
        /// in the listen function to detect a dead connection.
        fileprivate func tickle() {
            // Called on global queue
            DispatchQueue.main.async {
                if let listener = self.listener,
                    listener.socket != nil,
                    self.queue.isEmpty,
                    DispatchTime.now() >= self.nextAllowableNotificationTime {

                    // swiftlint:disable:next line_length
                    logger.info("Tickling \(self.listener?.socket?.remoteHostname ?? "-"):\(self.listener?.socket?.remotePort.description ?? "-"))")

                    self.nextAllowableNotificationTime = DispatchTime.now() + minimalTimeBetweenNotifications
                    let event: Event
                    do {
                        event = try Event(valueChangedOfCharacteristics: [])
                    } catch {
                        return logger.error("Could not create value change event: \(error)")
                    }
                    let data = event.serialized()
                    listener.writeOutOfBand(data)
                }
            }
        }

        private func sendQueue() {
            // Called on MAIN queue
            guard !queue.isEmpty else {
                return
            }
            defer {
                self.queue.removeAll()
            }
            let event: Event
            do {
                event = try Event(valueChangedOfCharacteristics: Array(queue.values))
            } catch {
                return logger.error("Could not create value change event: \(error)")
            }
            let data = event.serialized()
            // swiftlint:disable:next line_length
            logger.info("Value changed, notifying \(self.listener?.socket?.remoteHostname ?? "-"), event: \(data) (\(self.queue.count) updates)")
            listener?.writeOutOfBand(data)
        }
    }

    public class Connection: NSObject {
        var context = [String: Any]()
        var socket: Socket?
        var cryptographer: Cryptographer?
        var pairing: Pairing?
        var notificationQueue: NotificationQueue
        let writeQueue = DispatchQueue(label: "hap.server.connection")
        weak var server: Server?
        private let created = Date()

        init(server: Server) {
            // Called on global Queue
            notificationQueue = NotificationQueue()
            super.init()
            notificationQueue.listener = self
            self.server = server
        }

        func repeatingTickle() {
            // Called on global queue
            if socket != nil {
                let secondsBetweenTickles = 10 * 60
                writeQueue.asyncAfter(deadline: .now() + .seconds(secondsBetweenTickles)) { [weak self] in
                    self?.notificationQueue.tickle()
                    self?.repeatingTickle()
                }
            }
        }

        func listen(socket: Socket, application: @escaping Application) {
            // Called on global queue
            self.socket = socket

            // Regularly check if the connection is still alive
            repeatingTickle()

            let httpParser = HTTPParser(isRequest: true)
            let request = HTTPServerRequest(socket: socket, httpParser: httpParser)
            while true {
                var readBuffer = Data()
                do {
                    let byteCount = try socket.read(into: &readBuffer)
                    guard byteCount > 0 else {
                        // 0 bytes read signals the socket has closed
                        break
                    }
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

                // Fix to allow Bridges with spaces in name.
                // HomeKit POSTs contain a hostname with \\032 replacing the
                // space which causes Kitura httpParser to baulk on the
                // resulting URL. Replacing '\\032' with '-' in the hostname
                // allows Kitura to create a valid URL, and the value is not
                // used elsewhere.
                if let hostname = request.headers["Host"]?[0], (hostname.contains("\\032")) {
                    request.headers["Host"]![0] = hostname.replacingOccurrences(of: "\\032", with: "-")
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
                    try writeQueue.sync {
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
                    }
                } catch {
                    logger.error("Error while writing to socket", error: error)
                    break
                }
            }
            logger.debug("Closed connection to \(socket.remoteHostname):\(socket.remotePort)")
            self.tearDown()
        }

        func writeOutOfBand(_ data: Data) {
            // Called on MAIN queue
            guard let socket = socket else {
                return
            }
            writeQueue.async { [unowned self] in
                do {
                    var writeBuffer = data
                    if let cryptographer = self.cryptographer {
                        writeBuffer = try cryptographer.encrypt(writeBuffer)
                    }
                    try socket.write(from: writeBuffer)
                } catch {
                    logger.error("Error while writing to socket", error: error)
                    self.tearDown()
                }
            }
        }

        func tearDown() {
            // Called on MAIN queue (pairings()) or writeQueue (writeOutOfBand) or globalQueue (listen)
            DispatchQueue.main.async {

                func format(duration: TimeInterval) -> String {
                    let formatter = DateComponentsFormatter()
                    formatter.allowedUnits = [.day, .hour, .minute, .second]
                    formatter.unitsStyle = .abbreviated
                    formatter.maximumUnitCount = 1

                    return formatter.string(from: duration)!
                }

                if let socket = self.socket {
                    // swiftlint:disable:next line_length
                    logger.debug("Tearing down connection to \(socket.remoteHostname):\(socket.remotePort) after \(format(duration: Date().timeIntervalSince(self.created)))")
                    self.writeQueue.async {
                        // Close after any write operation is complete
                        Socket.forceClose(socketfd: socket.socketfd)
                    }
                    self.server?.device.remove(listener: self)
                    self.socket = nil
                }
            }
        }

        var isAuthenticated: Bool {
            return cryptographer != nil
        }
    }
}
