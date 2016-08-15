import Foundation
import HTTP
import Evergreen

class Delegate: NSObject, NetServiceDelegate, StreamDelegate {
    var server: HTTP.Server

    init(server: HTTP.Server) {
        self.server = server
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        print("didNotPublish", errorDict)
        abort()
    }

    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: NSOutputStream) {
        server.accept(inputStream: inputStream, outputStream: outputStream)
    }
}

func root(connection: Connection, request: Request) -> Response {
    return Response(status: .ok, text: "Nothing to see here. Pair this Homekit Accessory with an iOS device.")
}

import CLibSodium
import HKDF
import SRP
import CryptoSwift

let storage = try FileStorage(path: "Switch")

let livingRoomSwitch = { () -> Accessory in
    let identify = Characteristic(id: 2, type: .identify, permissions: [.write], format: .bool)
    let manufacturer = Characteristic(id: 3, type: .manufacturer, value: "Bouke", permissions: [.read], format: .string)
    let model = Characteristic(id: 4, type: .model, value: "Switch 2000", permissions: [.read], format: .string)
    let name = Characteristic(id: 5, type: .name, value: "Switch", permissions: [.read], format: .string)
    let serialNumber = Characteristic(id: 6, type: .serialNumber, value: "undefined", permissions: [.read], format: .string)
    let info = Service(id: 1, type: .info, characteristics: [identify, manufacturer, model, name, serialNumber])

    let characteristic = Characteristic(id: 8, type: .on, value: false, permissions: [.read, .write, .events], format: .bool)

    let service = Service(id: 7, type: .switch, characteristics: [characteristic])

    return Accessory(id: 1, type: .switch, services: [info, service])
}()

let device = Device(name: "Switch", pin: "001-02-003", storage: storage, accessories: [livingRoomSwitch])

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
    ("/pair-verify", pairVerify),
    ("/accessories", accessories),
    ("/characteristics", characteristics),
    ("/pairings", pairings)
])

let encryption = EncryptionMiddleware()

let httpServer = Server(application: router.application, streamMiddleware: [encryption])

let delegate = Delegate(server: httpServer)

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

log("Listening on port \(service.port)", forLevel: .info)

withExtendedLifetime((delegate, service)) {
    RunLoop.current.run()
}
