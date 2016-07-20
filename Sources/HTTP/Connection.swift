import Foundation

public protocol ConnectionMiddleware: Hashable {
    func handle(incoming: Data, in: Connection) -> Data
    func handle(outgoing: Data, in: Connection) -> Data
}

public protocol Context {}

public class Connection: NSObject, StreamDelegate {
    weak var server: Server?

    let inputStream: InputStream
    let outputStream: NSOutputStream
    var request: Request
    var response: Response?
//    var context: [ConnectionMiddleware: Context] = [:]

    init(server: Server, inputStream: InputStream, outputStream: NSOutputStream) {
        self.server = server
        self.inputStream = inputStream
        self.outputStream = outputStream
        self.request = Request()
        super.init()
        open()
    }

    func open() {
        inputStream.delegate = self
        outputStream.delegate = self

        inputStream.open()
        outputStream.open()

        inputStream.schedule(in: RunLoop.main, forMode: .defaultRunLoopMode)
    }

    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (aStream, eventCode) {
        case (_, Stream.Event.openCompleted): break

        case (inputStream, Stream.Event.hasBytesAvailable):
            var buffer = Data(count: 1024)!
            buffer.count = buffer.withUnsafeMutableBytes {
                inputStream.read($0, maxLength: buffer.count)
            }

            buffer = server!.connectionMiddleware.reduce(buffer) { $1.handle(incoming: $0, in: self) }

            try! request.append(data: buffer)

            if request.isHeaderComplete {
                response = server?.application(request)
                response!.headers["Connection"] = "Keep-Alive"
                request = Request()

                inputStream.remove(from: .main, forMode: .defaultRunLoopMode)
                outputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
            }

        case (outputStream, Stream.Event.hasSpaceAvailable):
            print(response?.status)
            guard let serialized = response?.serialized() else {
                abort()
            }

            let data = server!.connectionMiddleware.reversed().reduce(serialized) { $1.handle(outgoing: $0, in: self) }

            let written = data.withUnsafeBytes {
                outputStream.write($0, maxLength: data.count)
            }
            response = nil

            precondition(written == data.count)

            outputStream.remove(from: .main, forMode: .defaultRunLoopMode)
            inputStream.schedule(in: .main, forMode: .defaultRunLoopMode)

        case (_, Stream.Event.endEncountered), (_, Stream.Event.errorOccurred):
            print("end encountered, closing")
            close()

        default: break
        }
    }

    func close() {
        print("closing...")
        server?.forget(connection: self)
        inputStream.close()
        outputStream.close()
    }
    
    deinit {
        print("deinit, closing...")
        close()
    }
}
