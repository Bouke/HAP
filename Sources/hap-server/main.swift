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
    "pv": "1.0".data(using: .utf8)!, // state
    "id": device.identifier.data(using: .utf8)!, // identifier
    "c#": "1".data(using: .utf8)!, // version
    "s#": "1".data(using: .utf8)!, // state
    "sf": (device.isPaired ? "1" : "0").data(using: .utf8)!, // discoverable
    "ff": "0".data(using: .utf8)!, // mfi compliant
    "md": device.name.data(using: .utf8)!, // name
    "ci": device.accessories[0].type.rawValue.data(using: .utf8)!, // category identifier @todo use `bridge` if >1 accessory
]

service.setTXTRecord(NetService.data(fromTXTRecord: config))
service.delegate = delegate
service.publish(options: [.listenForConnections])

log("Listening on port \(service.port)", forLevel: .info)

withExtendedLifetime((delegate, service)) {
    RunLoop.current.run()
}

// see https://github.com/krzyzanowskim/CryptoSwift/issues/304
//let c = Cryptographer(sharedKey: Data(hex: "352ce52e8d7a6b964c061faba60c806271ae47b1391c36169050f150fac5c770")!)
//print(try c.decrypt(Data()))
//print(try c.decrypt(Data(hex: "a800ab7faf90ffa83a889fb690db37b5f9e2d51c25a2bbc2c52b01264333d43022564aac46075deaaf4ac7852ebabf0c0ab99cdb486259afdc078ce431498cbdedf7fb4b92aabe49f121fd4650d5f39690364101d6a310e9e67135a63c06e1d4010b08b3be3c034ae6042092bcbed6fb2451005b93f01a4965663635f51a6e37567ddac5135d445342d2bc49277f238e66d651cebcc6cfd4802022738d932e495d457dc5bc23634ff86a9187a102a3491041200a3dbb16d79889")!))
