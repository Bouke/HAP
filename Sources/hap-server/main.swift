import Foundation
import HTTP
import func Evergreen.getLogger
import HAP

fileprivate let logger = getLogger("hap")

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

let timer = DispatchSource.makeTimerSource()
timer.scheduleRepeating(deadline: .now() + .seconds(5), interval: 5)
timer.setEventHandler(handler: {
    livingRoomSwitch.switch.on.value = !(livingRoomSwitch.switch.on.value ?? false)
})
timer.resume()

let server = Server(device: device, port: 8000)
server.publish()
server.listen()

//or run the runloop yourself:
//withExtendedLifetime(server) {
//    RunLoop.current.run()
//}
