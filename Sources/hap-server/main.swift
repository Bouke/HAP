import Foundation
import HTTP
import func Evergreen.getLogger
import HAP

fileprivate let logger = getLogger("demo")

getLogger("hap").logLevel = .info
getLogger("http").logLevel = .info

let storage = try FileStorage(path: "db")

let livingRoomLightbulb = Accessory.Lightbulb(aid: 1)
livingRoomLightbulb.lightbulb.on.onValueChange.append({ value in
    logger.info("livingRoomSwitch changed value: \(value)")
})

let bedroomNightStand = Accessory.Lightbulb(aid: 2)
bedroomNightStand.lightbulb.on.onValueChange.append({ value in
    logger.info("bedroomNightStand changed value: \(value)")
})

let device = Device(name: "Bridge", pin: "123-44-321", storage: storage, accessories: [
    livingRoomLightbulb,
    bedroomNightStand,
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
