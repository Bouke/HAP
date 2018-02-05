/// The HAP `Device` calls the methods of this delegate to report HAP
/// related events. Implement this protocol in an app-specific object and use
/// the methods to update your app. For example, you might want to show the
/// device's pairing state, or the value of certain characteristics.
public protocol DeviceDelegate: class {
    /// Tells the delegate that a controller subscribed for updates.
    ///
    /// - Parameters:
    ///   - accessory: the accessory to which the characteristic's service
    ///     belongs
    ///   - service: the service to which the characteristic belongs
    ///   - characteristic: the characteristic that was subscribed to
    func characteristicListenerDidSubscribe(
        _ accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic)

    /// Tells the delegate that a controller unsubscribed from updates.
    ///
    /// - Parameters:
    ///   - accessory: the accessory to which the characteristic's service
    ///     belongs
    ///   - service: the service to which the characteristic belongs
    ///   - characteristic: the characteristic that was unsubscribed from
    func characteristicListenerDidUnsubscribe(
        _ accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic)

    /// Tells the delegate that identification of the device was requested.
    ///
    /// When the user configures a device, there might be multiple similar
    /// devices. In order to identify the individual device, HAP
    /// accommodates for an identification event. When possible, you should
    /// make the physical device emit sound and/or light for the user to be
    /// able to identify the device.
    func didRequestIdentification()

    /// Tells the delegate that identification of an accessory was requested.
    ///
    /// When the user configures an accessory, there might be multiple similar
    /// accessories. In order to identify the individual accessory, HAP
    /// accommodates for an identification event. When possible, you should
    /// make the physical accessory emit sound and/or light for the user to be
    /// able to identify the accessory.
    ///
    /// - Parameter accessory: accessory to be identified
    func didRequestIdentificationOf(_ accessory: Accessory)

    /// Tells the delegate that the Device PairingState has changed.
    ///
    func didChangePairingState(from: PairingState, to: PairingState)

    /// Tells the delegate that the value of a characteristic has changed.
    ///
    /// - Parameters:
    ///   - accessory: the accessory to which the characteristic's service
    ///     belongs
    ///   - service: the service to which the characteristic belongs
    ///   - characteristic: the characteristic that was changed
    ///   - newValue: the new value of the characteristic
    func characteristic<T>(
        _ characteristic: GenericCharacteristic<T>,
        ofService: Service,
        ofAccessory: Accessory,
        didChangeValue: T?)
}

public extension DeviceDelegate {
    func characteristicListenerDidSubscribe(
        _ accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic) { }

    func characteristicListenerDidUnsubscribe(
        _ accessory: Accessory,
        service: Service,
        characteristic: AnyCharacteristic) { }

    func didRequestIdentification() { }

    func didRequestIdentificationOf(_ accessory: Accessory) { }

    func didChangePairingState(from: PairingState, to: PairingState) { }

    func characteristic<T>(
        _ characteristic: GenericCharacteristic<T>,
        ofService: Service,
        ofAccessory: Accessory,
        didChangeValue: T?) { }
}
