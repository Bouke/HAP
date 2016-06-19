//
//  http.swift
//  HAP
//
//  Created by Bouke Haarsma on 19-06-16.
//
//

import Foundation

struct Request {
    var method: String
    var path: String
    var version: String
    var headers: [String: String]
    var body: String?
}

struct Response {
    var status: String
    var headers: [String: String]
    var body: String?
}

typealias Application = (Request) -> Response

class Server: NSObject, StreamDelegate {
    var application: Application

    init(application: Application) {
        self.application = application
    }

    var connections = [Stream: Connection]()

    func accept(inputStream: InputStream, outputStream: NSOutputStream) {
        connections[inputStream] = Connection(inputStream: inputStream, outputStream: outputStream)
        inputStream.schedule(in: RunLoop.main(), forMode: RunLoopMode.defaultRunLoopMode)
        inputStream.open()
        inputStream.delegate = self
    }

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        let inputStream = aStream as! InputStream
        let connection = connections[inputStream]!

        switch eventCode {
        case Stream.Event.openCompleted: print("openCompleted")
        case Stream.Event.hasBytesAvailable:
            if !connection.read() {
                connections[inputStream] = nil
            }
            print(connection.state)
            if connection.state == .response {
                let response = application(connection.request!)
                print(response)
                connection.outputStream.open()
                print(connection.outputStream.write(response.status, maxLength: response.status.utf8.count))
                connection.close()
            }
        case Stream.Event.endEncountered: print("endEncountered")
        default: print(eventCode)
        }
    }
}


class Connection {
    var inputStream: InputStream
    var outputStream: NSOutputStream
    var request: Request?
    var inputBuffer = Data()
    var state = State.headers

    enum State {
        case headers
        case body
        case response
    }

    init(inputStream: InputStream, outputStream: NSOutputStream) {
        self.inputStream = inputStream
        self.outputStream = outputStream
    }

    func read() -> Bool {
        var buffer = [UInt8](repeating: 0, count: 1024)

        switch inputStream.read(&buffer, maxLength: buffer.count) {
        case -1:
            return false
        case 0:
            return true
        case let count:
            inputBuffer.append(&buffer, count: count)

            switch state {
            case .headers: readHeaders()
            case .body: abort()
            case .response: abort()
            }

            if state == .response {

            }

            print(request)
            return true
        }
    }

    func readHeaders() {
        var from = inputBuffer.startIndex
        var colon: Data.Index?
        for pos in inputBuffer.indices {
            switch inputBuffer[pos] {
            case 13 where inputBuffer[inputBuffer.index(after: pos)] == 10:
                if from == pos {
                    _ = inputBuffer.dropFirst(pos)
                    parseHeaders()
                    return
                    // end of headers
                } else if request == nil {
                    let line = String(bytes: inputBuffer[from..<pos], encoding: .utf8)!.components(separatedBy: " ")
                    request = Request(method: line[0], path: line[1], version: line[2], headers: [:], body: nil)
                } else {
                    guard let key = String(bytes: inputBuffer[from..<colon!], encoding: .utf8)?.lowercased(), value = String(bytes: inputBuffer[inputBuffer.index(colon!, offsetBy: 2)..<pos], encoding: .utf8) else {
                        abort()
                    }
                    request!.headers[key] = value
                }
                from = inputBuffer.index(pos, offsetBy: 2)
                colon = nil
            case 58 where colon == nil:
                colon = pos
            default: break
            }
        }
    }

    func parseHeaders() {
        print(request?.headers["content-length"])
        state = .response
    }

    func close() {
        inputStream.close()
        outputStream.close()
    }

    deinit {
        close()
    }
}

