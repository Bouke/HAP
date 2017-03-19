import Foundation
import func Evergreen.getLogger
import HAP

fileprivate let logger = getLogger("demo")

getLogger("hap").logLevel = .info
getLogger("http").logLevel = .info

let storage = try FileStorage(path: "db")

let livingRoomLightbulb = Accessory.Lightbulb(info: .init(name: "Living Room"))
livingRoomLightbulb.lightbulb.on.onValueChange.append({ value in
    logger.info("livingRoomSwitch changed value: \(value)")
})

let bedroomNightStand = Accessory.Lightbulb(info: .init(name: "Bedroom"))
bedroomNightStand.lightbulb.on.onValueChange.append({ value in
    logger.info("bedroomNightStand changed value: \(value)")
})

let device = Device(name: "Bridge", pin: "123-44-321", storage: storage, accessories: [
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
    .SecuritySystem(info: .init(name: "Alarm")),
])
device.onIdentify.append({ acc in
    logger.info("Got identified: \(acc)")
})

let timer = DispatchSource.makeTimerSource()
timer.scheduleRepeating(deadline: .now() + .seconds(5), interval: 5)
timer.setEventHandler(handler: {
    livingRoomLightbulb.lightbulb.on.value = !(livingRoomLightbulb.lightbulb.on.value ?? false)
})
timer.resume()

let server = Server(device: device, port: 8000)
server.publish()
server.listen()

//or run the runloop yourself:
//withExtendedLifetime(server) {
//    RunLoop.current.run()
//}
