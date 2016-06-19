import Foundation

class Delegate: NSObject, NetServiceDelegate, StreamDelegate {
    var server: Server

    init(application: Application) {
        server = Server(application: application)
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("didNotPublish", errorDict)
        abort()
    }

    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: NSOutputStream) {
        server.accept(inputStream: inputStream, outputStream: outputStream)
    }
}

func identifier() -> String {
    return (1...6).map({ _ in String(arc4random() & 255, radix: 16, uppercase: false) }).joined(separator: ":")
}

func application(request: Request) -> Response {
    return Response(status: "200", headers: [:], body: "Hello, world")
}

let delegate = Delegate(application: application)

let service = NetService(domain: "local.", type: "_hap._tcp.", name: "Swift's Switch", port: 8000)
let config: [String: Data] = [
    "id": identifier().data(using: .utf8)!, // identifier
    "c#": "3".data(using: .utf8)!, // version
    "s#": "1".data(using: .utf8)!, // state
    "sf": "1".data(using: .utf8)!, // discoverable
    "ff": "0".data(using: .utf8)!, // mfi compliant
    "md": "Swift's Switch".data(using: .utf8)!, // name
    "ci": "8".data(using: .utf8)!, // category identifier -- switch
]

service.setTXTRecord(NetService.data(fromTXTRecord: config))

service.delegate = delegate
service.publish([.listenForConnections])
print(service.port)

withExtendedLifetime((delegate, service)) {
    RunLoop.current().run()
}



// post /identify -> ??

// pair
// post /pair-setup
// enter code
// post /pair-setup -> fail, try again
// enter code
// post /pair-setup -> succeeds, multiple posts to here
// post /pair-verify -> ?
// GET /accessories
// POST /pairings method ADD
// paired

// setup (?)
//GET /characteristics


// unpair

// post /pairings method DELETE -> unpair
// post /pair-verify -> ??
