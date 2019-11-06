import Foundation
import Logging
import HAP

fileprivate let logger = Logger(label: "bridge")

#if os(macOS)
    import Darwin
#elseif os(Linux)
    import Dispatch
    import Glibc
#endif

let storage = FileStorage(filename: "configuration.json")
if CommandLine.arguments.contains("--recreate") {
    logger.warning("Dropping all pairings, keys")
    try storage.write(Data())
}

let livingRoomLightbulb = Accessory.Lightbulb(info: Service.Info(name: "Living Room", serialNumber: "00002"))
let bedroomNightStand = Accessory.Lightbulb(info: Service.Info(name: "Bedroom", serialNumber: "00003"))

let device = Device(
    bridgeInfo: Service.Info(name: "Bridge", serialNumber: "00001"),
    setupCode: "123-44-321",
    storage: storage,
    accessories: [
        livingRoomLightbulb,
        bedroomNightStand
//        Accessory.Door(info: Service.Info(name: "Front Door", serialNumber: "00005")),
//        Accessory.Switch(info: Service.Info(name: "Garden Lights", serialNumber: "00006")),
//        Accessory.Thermostat(info: Service.Info(name: "Living Room Thermostat", serialNumber: "00007")),
//        Accessory.Thermometer(info: Service.Info(name: "Office Thermometer", serialNumber: "00008")),
//        Accessory.Outlet(info: Service.Info(name: "Coffee Machine", serialNumber: "00009")),
//        Accessory.Window(info: Service.Info(name: "Toilet Window", serialNumber: "00010")),
//        Accessory.WindowCovering(info: Service.Info(name: "Shades", serialNumber: "00011")),
//        Accessory.Fan(info: Service.Info(name: "Living Room Ceiling Fan", serialNumber: "00012")),
//        Accessory.GarageDoorOpener(info: Service.Info(name: "Garage", serialNumber: "00013")),
//        Accessory.LockMechanism(info: Service.Info(name: "Front Door Lock", serialNumber: "00014")),
//        Accessory.SecuritySystem(info: Service.Info(name: "Alarm", serialNumber: "00015"))
    ])

class MyDeviceDelegate: DeviceDelegate {
    func didRequestIdentificationOf(_ accessory: Accessory) {
        logger.info("Requested identification of accessory \(String(describing: accessory.info.name.value ?? ""))")
    }

    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        logger.info("Characteristic \(characteristic) in service \(service.type) of accessory \(accessory.info.name.value ?? "") did change: \(String(describing: newValue))")
    }

    func characteristicListenerDidSubscribe(_ accessory: Accessory,
                                            service: Service,
                                            characteristic: AnyCharacteristic) {
        logger.info("Characteristic \(characteristic) in service \(service.type) of accessory \(accessory.info.name.value ?? "") got a subscriber")
    }

    func characteristicListenerDidUnsubscribe(_ accessory: Accessory,
                                              service: Service,
                                              characteristic: AnyCharacteristic) {
        logger.info("Characteristic \(characteristic) in service \(service.type) of accessory \(accessory.info.name.value ?? "") lost a subscriber")
    }
    
    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            printPairingInstructions()
        }
    }
    
    func printPairingInstructions() {
        if device.isPaired {
            print()
            print("The device is paired, either unpair using your iPhone or remove the configuration file `configuration.json`.")
            print()
        } else {
            print()
            print("Scan the following QR code using your iPhone to pair this device:")
            print()
            print(device.setupQRCode.asText)
            print()
        }
    }
}

var delegate = MyDeviceDelegate()
device.delegate = delegate
let server = try Server(device: device, listenPort: 8000)

// Stop server on interrupt.
var keepRunning = true
func stop() {
    DispatchQueue.main.async {
        logger.info("Shutting down...")
        keepRunning = false
    }
}
signal(SIGINT) { _ in stop() }
signal(SIGTERM) { _ in stop() }

logger.info("Initializing the server...")

// Switch the lights every 5 seconds.
let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now() + .seconds(1), repeating: .seconds(5))
timer.setEventHandler(handler: {
    livingRoomLightbulb.lightbulb.powerState.value = !(livingRoomLightbulb.lightbulb.powerState.value ?? false)
})
timer.resume()

delegate.printPairingInstructions()

withExtendedLifetime([delegate]) {
    if CommandLine.arguments.contains("--test") {
        logger.warning("Running runloop for 10 seconds...")
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 10))
    } else {
        while keepRunning {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
}

try server.stop()
logger.info("Stopped")
