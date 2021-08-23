public protocol AccessoryDelegate: AnyObject {
    /// Tells the delegate that the value of a characteristic has changed.
    ///
    /// - Parameters:
    ///   - ofService: the service to which the characteristic belongs
    ///   - ofAccessory: the accessory to which the characteristic's service
    ///     belongs
    ///   - characteristic: the characteristic that was changed
    ///   - didChangeValue: the new value of the characteristic
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService: Service,
                           ofAccessory: Accessory,
                           didChangeValue: T?)

}

public extension AccessoryDelegate {
    func characteristic<T>(_ characteristic: GenericCharacteristic<T>,
                           ofService: Service,
                           ofAccessory: Accessory,
                           didChangeValue: T?) { }
}
