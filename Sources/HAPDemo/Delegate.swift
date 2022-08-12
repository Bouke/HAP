import HAP
import Logging

class LoggingDeviceDelegate: DeviceDelegate {
    var logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func didRequestIdentificationOf(_ accessory: Accessory) {
        logger.info("Requested identification of accessory \(accessory.info.name.value ?? "?")")
    }

    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService service: Service,
                           ofAccessory accessory: Accessory,
                           didChangeValue newValue: T?) {
        logger.debug(
            """
            Characteristic \(characteristic) \
            in service \(service.type) \
            of accessory \(accessory.info.name.value ?? "") \
            did change: \(String(describing: newValue))
            """)
    }

    func characteristicListenerDidSubscribe(_ accessory: Accessory,
                                            service: Service,
                                            characteristic: AnyCharacteristic) {
        logger.debug(
            """
            Characteristic \(characteristic) \
            in service \(service.type) \
            of accessory \(accessory.info.name.value ?? "") got a subscriber
            """)
    }

    func characteristicListenerDidUnsubscribe(_ accessory: Accessory,
                                              service: Service,
                                              characteristic: AnyCharacteristic) {
        logger.debug(
            """
            Characteristic \(characteristic) \
            in service \(service.type) \
            of accessory \(accessory.info.name.value ?? "") \
            lost a subscriber
            """)
    }

    func didChangePairingState(from: PairingState, to: PairingState) {
        if to == .notPaired {
            printPairingInstructions()
        }
    }

    func printPairingInstructions() {
        if device.isPaired {
            print()
            print(
                """
                The device is paired, either unpair using your iPhone or \
                remove the configuration file `configuration.json`.
                """)
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
