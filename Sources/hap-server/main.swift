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

let storage = try FileStorage(path: "db")
if CommandLine.arguments.contains("--recreate") {
    logger.info("Dropping all pairings, keys")
    try storage.removeAll()
}

let livingRoomLightbulb = Accessory.Lightbulb(info: Service.Info(name: "Living Room"))
livingRoomLightbulb.lightbulb.on.onValueChange.append({ value in
    logger.info("livingRoomSwitch changed value: \(String(describing: value))")
})

let bedroomNightStand = Accessory.Lightbulb(info: Service.Info(name: "Bedroom"))
bedroomNightStand.lightbulb.on.onValueChange.append({ value in
    logger.info("bedroomNightStand changed value: \(String(describing: value))")
})

let device = Device(
    bridgeInfo: Service.Info(name: "Bridge"),
    setupCode: "123-44-321",
    storage: storage,
    accessories: [
        livingRoomLightbulb,
        bedroomNightStand,
        Accessory.Door(info: Service.Info(name: "Front Door")),
        Accessory.Switch(info: Service.Info(name: "Garden Lights")),
        Accessory.Thermostat(info: Service.Info(name: "Living Room Thermostat")),
        Accessory.Thermometer(info: Service.Info(name: "Office Thermometer")),
        Accessory.Outlet(info: Service.Info(name: "Coffee Machine")),
        Accessory.Window(info: Service.Info(name: "Toilet Window")),
        Accessory.WindowCovering(info: Service.Info(name: "Shades")),
        Accessory.Fan(info: Service.Info(name: "Living Room Ceiling Fan")),
        Accessory.GarageDoorOpener(info: Service.Info(name: "Garage")),
        Accessory.LockMechanism(info: Service.Info(name: "Front Door Lock")),
        Accessory.SecuritySystem(info: Service.Info(name: "Alarm"))
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
