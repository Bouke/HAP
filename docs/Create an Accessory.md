Create an Accessory
===================

The following code snippet how you would model a fictious accessory
representing a mobile power bank.

```swift
class PowerBankAccessory: Accessory {
    let service = PowerBankService()
    init(info: Service.Info) {
        super.init(info: info, type: .outlet, services: [service])
    }
}
class PowerBankService: Service {
    public let on = GenericCharacteristic<Bool>(
        type: .on,
        value: false)
    public let inUse = GenericCharacteristic<Bool>(
        type: .outletInUse,
        value: true,
        permissions: [.read, .events])
    public let batteryLevel = GenericCharacteristic<Double>(
        type: .batteryLevel,
        value: 100,
        permissions: [.read, .events])

    init() {
        super.init(type: .outlet, characteristics: [
            AnyCharacteristic(on),
            AnyCharacteristic(inUse),
            AnyCharacteristic(batteryLevel)
        ])
    }
}
```
