extension Sequence {
    func dictionary<Key: Hashable>(key: (Self.Iterator.Element) -> Key) -> [Key: Self.Iterator.Element] {
        var dict: [Key: Self.Iterator.Element] = [:]
        for element in self {
            dict[key(element)] = element
        }
        return dict
    }
    func dictionary<Key: Hashable, Value>(
        key: (Self.Iterator.Element) -> Key,
        value: (Self.Iterator.Element) -> Value
    ) -> [Key: Value] {
        var dict: [Key: Value] = [:]
        for element in self {
            dict[key(element)] = value(element)
        }
        return dict
    }
}
