import Foundation
import KituraNet

public protocol StreamMiddleware {
    func parse(input data: Data, forConnection connection: Connection) -> Data
    func parse(output data: Data, forConnection connection: Connection) -> Data
}

public class Connection: NSObject, StreamDelegate {
    weak var server: Server?

    let inputStream: InputStream
    let outputStream: OutputStream

    let httpParser = HTTPParser(isRequest: true)
    public private(set) var request: HTTPServerRequest
    public private(set) var response: Response?

    public typealias Context = [String: Any]
    public var context = Context()


    public var dateFormatter = { () -> DateFormatter in
        let f = DateFormatter()
        f.timeZone = TimeZone(identifier: "GMT")
        f.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss zzz"
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    init(server: Server, inputStream: InputStream, outputStream: OutputStream) {
        self.server = server
        self.inputStream = inputStream
        self.outputStream = outputStream
        self.request = HTTPServerRequest(httpParser: httpParser)
        super.init()
        open()

    }

    func open() {
        inputStream.delegate = self
        outputStream.delegate = self

        inputStream.open()
        outputStream.open()

        inputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
    }

    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch (aStream, eventCode) {
        case (_, Stream.Event.openCompleted): break

        case (inputStream, Stream.Event.hasBytesAvailable):
            var buffer = Data(count: 1024)
            buffer.count = buffer.withUnsafeMutableBytes {
                inputStream.read($0, maxLength: buffer.count)
            }

            // Used [].reduce before, but resulted in corrupted memory; this as a workaround
            for middleware in server!.streamMiddleware {
                buffer = middleware.parse(input: buffer, forConnection: self)
            }

            _ = buffer.withUnsafeBytes {
                httpParser.execute($0, length: buffer.count)
            }
            print("Got \(buffer.count) bytes, complete? \(httpParser.completed)")

            if httpParser.completed {
                request.parsingCompleted()

                logger.debug("Request \(self.httpParser.urlString)")

                response = server?.application(self, request)
                response?.headers["Date"] = dateFormatter.string(from: Date())
                // @todo set Connection=Keep-Alive when appriopriate

                httpParser.reset()
                inputStream.remove(from: .main, forMode: .defaultRunLoopMode)
                outputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
            }

        case (outputStream, Stream.Event.hasSpaceAvailable):
            defer {
                outputStream.remove(from: .main, forMode: .defaultRunLoopMode)
                inputStream.schedule(in: .main, forMode: .defaultRunLoopMode)
            }
            guard let response = response else {
                preconditionFailure("No response available")
            }
            
            logger.debug("Response \(response)")
            if let responseText = String(data: response.serialized(), encoding: .utf8) {
                logger.debug(responseText)
            }

            let data = server!.streamMiddleware.reversed().reduce(response.serialized()) {
                $1.parse(output: $0, forConnection: self)
            }

            let written = data.withUnsafeBytes {
                outputStream.write($0, maxLength: data.count)
            }

            precondition(written == data.count)

        case (_, Stream.Event.endEncountered), (_, Stream.Event.errorOccurred):
            close()

        default: break
        }
    }
    
    #if os(Linux)
        public func stream(_ aStream: Stream, handleEvent eventCode: Stream.Event) {
            stream(aStream, handle: eventCode)
        }
    #endif

    // Out-of-band messaging (used for events)
    public func write(_ data: Data) {
        // @todo use runloop to write the data
        let data = server!.streamMiddleware.reversed().reduce(data) { $1.parse(output: $0, forConnection: self) }

        let written = data.withUnsafeBytes {
            outputStream.write($0, maxLength: data.count)
        }
        precondition(written == data.count)
    }

    func close() {
        inputStream.close()
        outputStream.close()
        server?.forget(connection: self)
    }

    deinit {
        precondition(inputStream.streamStatus == .closed || inputStream.streamStatus == .error)
        precondition(outputStream.streamStatus == .closed || outputStream.streamStatus == .error)
    }
}
