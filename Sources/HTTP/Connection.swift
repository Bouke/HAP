import Foundation


class Connection: NSObject, StreamDelegate {
    weak var server: Server?

    let inputStream: InputStream
    let outputStream: NSOutputStream
    var request: Request
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
        outputStream.delegate = self

        inputStream.open()
        outputStream.open()

        inputStream.schedule(in: RunLoop.main, forMode: .defaultRunLoopMode)
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (aStream, eventCode) {
        case (_, Stream.Event.openCompleted): break

        case (inputStream, Stream.Event.hasBytesAvailable):
            var buffer = Data(capacity: 1024)
            buffer.count = 1024
            buffer.count = buffer.withUnsafeMutableBytes {
                inputStream.read($0, maxLength: 1024)
            }
            precondition(request.append(data: buffer))

            if request.isHeaderComplete {
                response = server?.application(request)
                response!.headers["Connection"] = "Keep-Alive"
                request = Request()

                inputStream.remove(from: .main, forMode: .defaultRunLoopMode)
                outputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
            }

        case (outputStream, Stream.Event.hasSpaceAvailable):
            guard let data = response?.serialized() else {
                abort()
//                print("nothing to write...")
//                return
            }
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
