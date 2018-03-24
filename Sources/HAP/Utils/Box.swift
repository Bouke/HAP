struct Box<T: Any>: Hashable, Equatable {
    let value: T

    init(_ value: T) {
        self.value = value
    }

    var object: AnyObject {
        #if os(macOS)
            return value as AnyObject
        #elseif os(Linux)
            // swiftlint:disable:next force_cast
            return value as! AnyObject
        #endif
    }

    var hashValue: Int {
        return ObjectIdentifier(object).hashValue
    }

    static func == (lhs: Box<T>, rhs: Box<T>) -> Bool {
        return ObjectIdentifier(lhs.object) == ObjectIdentifier(rhs.object)
    }
}
