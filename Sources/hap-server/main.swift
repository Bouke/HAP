import Foundation
import HTTP

class Delegate: NSObject, NetServiceDelegate, StreamDelegate {
    var server: HTTP.Server

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

func root(request: Request) -> Response {
    return Response(status: .OK, text: "Nothing to see here. Pair this Homekit Accessory with an iOS device.")
}

import CLibSodium
import HKDF
import SRP
import CryptoSwift

let device = Device(name: "Switch", pin: "001-02-003")

//TODO: converge into "Device()"
let username = "Pair-Setup"
let password = device.pin

import CommonCrypto

let group = Group.N3072
let alg = HashAlgorithm.SHA512

/* Create a salt+verification key for the user's password. The salt and
 * key need to be computed at the time the user's password is set and
 * must be stored by the server-side application for use during the
 * authentication process.
 */
let (salt, verificationKey) = createSaltedVerificationKey(username: username, password: password, group: group, alg: alg)

let server = Server(group: group, alg: alg, salt: salt, username: username, verificationKey: verificationKey)

//let ESC = "\u{001B}"
//let CSI = "\(ESC)["
//print("\(CSI)30;47m                        \(CSI)0m")
//print("\(CSI)30;47m    ┌──────────────┐    \(CSI)0m")
//print("\(CSI)30;47m    | (\(password) |    \(CSI)0m")
//print("\(CSI)30;47m    └──────────────┘    \(CSI)0m")
//print("\(CSI)30;47m                        \(CSI)0m")

let router = Router(routes: [
    ("/", root),
    ("/identify", identify),
    ("/pair-setup", pairSetup),
    ("/pair-verify", pairVerify)
])

let delegate = Delegate(application: router.application)

let service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: 8000)
let config: [String: Data] = [
    "id": device.identifier.data(using: .utf8)!, // identifier
    "c#": "3".data(using: .utf8)!, // version
    "s#": "1".data(using: .utf8)!, // state
    "sf": "1".data(using: .utf8)!, // discoverable
    "ff": "0".data(using: .utf8)!, // mfi compliant
    "md": device.name.data(using: .utf8)!, // name
    "ci": "8".data(using: .utf8)!, // category identifier -- switch
]

service.setTXTRecord(NetService.data(fromTXTRecord: config))
service.delegate = delegate
service.publish(options: [.listenForConnections])


print(service.port)

withExtendedLifetime((delegate, service)) {
    RunLoop.current.run()
}
