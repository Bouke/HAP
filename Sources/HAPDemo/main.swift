import Foundation
import HAP
import Logging

#if os(macOS)
    import Darwin
#elseif os(Linux)
    import Dispatch
    import Glibc
#endif

fileprivate let logger = Logger(label: "bridge")
LoggingSystem.bootstrap(createLogHandler)

#if DEBUG
    logger.warning(
        """
        ⚠️  It looks like you're running a debug build, which doesn't perform well. \
        Specify `-c release` for good performance.
        """)
#endif

let storage = FileStorage(filename: "configuration.json")
if CommandLine.arguments.contains("--recreate") {
    logger.warning("Dropping all pairings, keys")
    try storage.write(Data())
}

// Define two light bulb accessories.
let livingRoomLightbulb = Accessory.Lightbulb(info: Service.Info(name: "Living Room", serialNumber: "00002"))
let bedroomNightStand = Accessory.Lightbulb(info: Service.Info(name: "Bedroom", serialNumber: "00003"))

// And a security system with multiple zones and statuses fault and tampered.
let securitySystem = Accessory(
    info: Service.Info(name: "Multi-Zone", serialNumber: "A1803"),
    type: .securitySystem,
    services: [
        Service.SecuritySystem(characteristics: [.name("Zone A"), .statusFault(), .statusTampered()]),
        Service.SecuritySystem(characteristics: [.name("Zone B"), .statusFault(), .statusTampered()])
    ])

// Attach those to the bridge device.
let device = Device(
    bridgeInfo: Service.Info(name: "Bridge", serialNumber: "00001"),
    setupCode: "123-44-321",
    storage: storage,
    accessories: [
        livingRoomLightbulb,
        bedroomNightStand,
        securitySystem
    ])

// Attach a delegate that logs all activity.
var delegate = LoggingDeviceDelegate(logger: logger)
device.delegate = delegate

// Attach device to a server handling networking.
let server = try Server(device: device)

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

// Toggle the lights every 5 seconds.
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
