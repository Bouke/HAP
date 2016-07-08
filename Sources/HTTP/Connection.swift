import Foundation


class Connection: NSObject, StreamDelegate {
    weak var server: Server?

    let inputStream: InputStream
    let outputStream: NSOutputStream
    let request: Request
    var response: Response?

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
        inputStream.schedule(in: RunLoop.main, forMode: .defaultRunLoopMode)
        inputStream.open()
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (aStream, eventCode) {
        case (inputStream, Stream.Event.openCompleted): break

        case (inputStream, Stream.Event.hasBytesAvailable):
            var buffer = Data(capacity: 1024)
            buffer.count = 1024
            buffer.count = buffer.withUnsafeMutableBytes {
                inputStream.read($0, maxLength: 1024)
            }
            precondition(request.append(data: buffer))

            if request.isHeaderComplete {
                response = server?.application(request)

                outputStream.delegate = self
                outputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
                outputStream.open()
            }

        case (inputStream, Stream.Event.endEncountered): break


        case (outputStream, Stream.Event.openCompleted): break

        case (outputStream, Stream.Event.hasSpaceAvailable):
            guard let data = response?.serialized() else {
                abort()
            }
            let written = data.withUnsafeBytes {
                outputStream.write($0, maxLength: data.count)
            }

            precondition(written == data.count)
            close()

        default:
            close()
        }
    }

    func close() {
        server?.forget(connection: self)
        inputStream.close()
        outputStream.close()
    }
    
    deinit {
        close()
    }
}
