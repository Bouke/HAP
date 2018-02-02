import Foundation
import func Evergreen.getLogger
import HAP

fileprivate let logger = getLogger("demo")

#if os(macOS)
    import Darwin
#elseif os(Linux)
    import Dispatch
    import Glibc
#endif

getLogger("hap").logLevel = .debug
getLogger("hap.encryption").logLevel = .info
getLogger("hap.pair-verify").logLevel = .info

let storage = FileStorage(filename: "configuration.json")
if CommandLine.arguments.contains("--recreate") {
    logger.info("Dropping all pairings, keys")
    try storage.write(Data())
}

let livingRoomLightbulb = Accessory.Lightbulb(info: Service.Info(name: "Living Room", serialNumber: "00002"))
livingRoomLightbulb.lightbulb.on.onValueChange.append({ value in
    logger.info("livingRoomSwitch changed value: \(String(describing: value))")
})

let bedroomNightStand = Accessory.Lightbulb(info: Service.Info(name: "Bedroom", serialNumber: "00003"))
bedroomNightStand.lightbulb.on.onValueChange.append({ value in
    logger.info("bedroomNightStand changed value: \(String(describing: value))")
})

let device = Device(
    bridgeInfo: Service.Info(name: "Bridge", serialNumber: "00001"),
    setupCode: .override("123-44-321"),
    storage: storage,
    accessories: [
        livingRoomLightbulb,
        bedroomNightStand,
        Accessory.Door(info: Service.Info(name: "Front Door", serialNumber: "00005")),
        Accessory.Switch(info: Service.Info(name: "Garden Lights", serialNumber: "00006")),
        Accessory.Thermostat(info: Service.Info(name: "Living Room Thermostat", serialNumber: "00007")),
        Accessory.Thermometer(info: Service.Info(name: "Office Thermometer", serialNumber: "00008")),
        Accessory.Outlet(info: Service.Info(name: "Coffee Machine", serialNumber: "00009")),
        Accessory.Window(info: Service.Info(name: "Toilet Window", serialNumber: "00010")),
        Accessory.WindowCovering(info: Service.Info(name: "Shades", serialNumber: "00011")),
        Accessory.Fan(info: Service.Info(name: "Living Room Ceiling Fan", serialNumber: "00012")),
        Accessory.GarageDoorOpener(info: Service.Info(name: "Garage", serialNumber: "00013")),
        Accessory.LockMechanism(info: Service.Info(name: "Front Door Lock", serialNumber: "00014")),
        Accessory.SecuritySystem(info: Service.Info(name: "Alarm", serialNumber: "00015"))
    ])
device.onIdentify.append({ acc in
    logger.info("Got identified: \(String(describing: acc))")
})

let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now() + .seconds(1), repeating: .seconds(5))
timer.setEventHandler(handler: {
    livingRoomLightbulb.lightbulb.on.value = !(livingRoomLightbulb.lightbulb.on.value ?? false)
})
timer.resume()

var keepRunning = true
signal(SIGINT) { _ in
    logger.info("Caught interrupt, stopping...")
    DispatchQueue.main.async {
        keepRunning = false
    }
}

let server = try Server(device: device, port: 0)
server.start()

if CommandLine.arguments.contains("--test") {
    print("Running runloop for 10 seconds...")
    RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
} else {
    while keepRunning {
        RunLoop.current.run(until: Date().addingTimeInterval(2))
    }
}

server.stop()
logger.info("Stopped")
