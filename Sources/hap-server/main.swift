import Foundation
import func Evergreen.getLogger
import HAP

fileprivate let logger = getLogger("demo")

#if os(macOS)
    import Darwin
#elseif os(Linux)
    import Glibc
    import Dispatch
#endif

getLogger("hap").logLevel = .debug
getLogger("hap.encryption").logLevel = .info
getLogger("hap.pair-verify").logLevel = .info

let storage = try FileStorage(path: "db")
if CommandLine.arguments.contains("--recreate") {
    logger.info("Dropping all pairings, keys")
    try storage.removeAll()
}

let livingRoomLightbulb = Accessory.Lightbulb(info: .init(name: "Living Room"))
livingRoomLightbulb.lightbulb.on.onValueChange.append({ value in
    logger.info("livingRoomSwitch changed value: \(String(describing: value))")
})

let bedroomNightStand = Accessory.Lightbulb(info: .init(name: "Bedroom"))
bedroomNightStand.lightbulb.on.onValueChange.append({ value in
    logger.info("bedroomNightStand changed value: \(String(describing: value))")
})

let device = Device(
    bridgeInfo: .init(name: "Bridge"),
    setupCode: "123-44-321",
    storage: storage,
    accessories: [
        livingRoomLightbulb,
        bedroomNightStand,
        .Door(info: .init(name: "Front Door")),
        .Switch(info: .init(name: "Garden Lights")),
        .Thermostat(info: .init(name: "Living Room Thermostat")),
        .Thermometer(info: .init(name: "Office Thermometer")),
        .Outlet(info: .init(name: "Coffee Machine")),
        .Window(info: .init(name: "Toilet Window")),
        .WindowCovering(info: .init(name: "Shades")),
        .Fan(info: .init(name: "Living Room Ceiling Fan")),
        .GarageDoorOpener(info: .init(name: "Garage")),
        .LockMechanism(info: .init(name: "Front Door Lock")),
        .SecuritySystem(info: .init(name: "Alarm"))
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
