import Foundation
import HTTP
import func Evergreen.getLogger
import HAP

fileprivate let logger = getLogger("hap")

class Delegate: NSObject, NetServiceDelegate, StreamDelegate {
    var server: HTTP.Server

    init(server: HTTP.Server) {
        self.server = server
    }

    func netService(_ sender: NetService, didNotPublish errorDict: [String : NSNumber]) {
        logger.error("didNotPublish: \(errorDict)")
        abort()
    }

    func netService(_ sender: NetService, didAcceptConnectionWith inputStream: InputStream, outputStream: OutputStream) {
        server.accept(inputStream: inputStream, outputStream: outputStream)
    }
}

let storage = try FileStorage(path: "Switch")

let livingRoomSwitch = Accessory.Switch(aid: 1)
livingRoomSwitch.info.manufacturer.value = "Bouke"
livingRoomSwitch.info.model.value = "undefined"
livingRoomSwitch.info.serialNumber.value = "undefined"
livingRoomSwitch.info.name.value = "Switch"
let bedroomNightStand = Accessory.Lightbulb(aid: 2)

livingRoomSwitch.`switch`.on.onValueChange.append({ value in
    logger.info("Switch changed value: \(value)")
})

let device = Device(name: "Switch", pin: "001-02-003", storage: storage, accessories: [livingRoomSwitch, bedroomNightStand])

let application = HAP.root(device: device)

let encryption = EncryptionMiddleware()

let httpServer = Server(application: application, streamMiddleware: [encryption])

let delegate = Delegate(server: httpServer)

let service = NetService(domain: "local.", type: "_hap._tcp.", name: device.name, port: 8000)
let config: [String: Data] = [
    "pv": "1.0".data(using: .utf8)!, // state
    "id": device.identifier.data(using: .utf8)!, // identifier
    "c#": "1".data(using: .utf8)!, // version
    "s#": "1".data(using: .utf8)!, // state
    "sf": (device.isPaired ? "0" : "1").data(using: .utf8)!, // discoverable
    "ff": "0".data(using: .utf8)!, // mfi compliant
    "md": device.name.data(using: .utf8)!, // name
//    "ci": device.accessories[0].type.rawValue.data(using: .utf8)! // category identifier @todo use `bridge` if >1 accessory
    "ci": AccessoryType.bridge.rawValue.data(using: .utf8)!
]

service.setTXTRecord(NetService.data(fromTXTRecord: config))
service.delegate = delegate
service.publish(options: [.listenForConnections])

logger.info("Listening on port \(service.port)")

let timer = DispatchSource.makeTimerSource()
timer.scheduleRepeating(deadline: .now() + .seconds(5), interval: 5)
timer.setEventHandler(handler: {
    livingRoomSwitch.switch.on.value = !(livingRoomSwitch.switch.on.value ?? false)
})
timer.resume()

withExtendedLifetime((delegate, service)) {
    RunLoop.current.run()
}


// see https://github.com/krzyzanowskim/CryptoSwift/issues/304
//let c = Cryptographer(sharedKey: Data(hex: "352ce52e8d7a6b964c061faba60c806271ae47b1391c36169050f150fac5c770")!)
//print(try c.decrypt(Data()))
//print(try c.decrypt(Data(hex: "a800ab7faf90ffa83a889fb690db37b5f9e2d51c25a2bbc2c52b01264333d43022564aac46075deaaf4ac7852ebabf0c0ab99cdb486259afdc078ce431498cbdedf7fb4b92aabe49f121fd4650d5f39690364101d6a310e9e67135a63c06e1d4010b08b3be3c034ae6042092bcbed6fb2451005b93f01a4965663635f51a6e37567ddac5135d445342d2bc49277f238e66d651cebcc6cfd4802022738d932e495d457dc5bc23634ff86a9187a102a3491041200a3dbb16d79889")!))
