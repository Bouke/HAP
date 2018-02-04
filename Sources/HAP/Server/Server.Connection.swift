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

        private func sendQueue() {
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

        override init() {
            notificationQueue = NotificationQueue()
            super.init()
            notificationQueue.listener = self
        }

        func listen(socket: Socket, application: @escaping Application) {
            self.socket = socket
            let httpParser = HTTPParser(isRequest: true)
            let request = HTTPServerRequest(socket: socket, httpParser: httpParser)
            while true {
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

            self.socket = nil
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
}
