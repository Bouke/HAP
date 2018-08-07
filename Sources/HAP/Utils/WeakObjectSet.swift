//adapted from: http://stackoverflow.com/a/36184182

class WeakObject<T: AnyObject>: Equatable, Hashable {
    weak var object: T?
    init(_ object: T) {
        self.object = object
    }

    var hashValue: Int {
        if let object = self.object {
            return ObjectIdentifier(object).hashValue
        } else {
            return 0
        }
    }

    static func == <T> (lhs: WeakObject<T>, rhs: WeakObject<T>) -> Bool {
        return lhs.object === rhs.object
    }
}

struct WeakObjectSet<T: AnyObject>: Sequence, ExpressibleByArrayLiteral where T: Hashable {
    var objects: Set<WeakObject<T>>

    init() {
        self.objects = Set()
    }

    init(objects: [T]) {
        self.objects = Set(objects.map { WeakObject($0) })
    }

    var allObjects: [T] {
        return objects.compactMap { $0.object }
    }

    func contains(object: T) -> Bool {
        return self.objects.contains(WeakObject(object))
    }

    mutating func addObject(object: T) {
        cleanup()
        self.objects.formUnion([WeakObject(object)])
    }

    mutating func addObjects(objects: [T]) {
        cleanup()
        self.objects.formUnion(objects.map { WeakObject($0) })
    }

    mutating func remove(_ member: T) -> T? {
        cleanup()
        return self.objects.remove(WeakObject(member))?.object
    }

    mutating func cleanup() {
        objects = objects.filter { $0.object != nil }
    }

    /// Complexity: O(n)
    var isEmpty: Bool {
        return allObjects.isEmpty
    }

    // Sequence
    func makeIterator() -> IndexingIterator<[T]> {
        return allObjects.makeIterator()
    }

    // ExpressibleByArrayLiteral
    init(arrayLiteral elements: T...) {
        self.objects = Set(elements.map { WeakObject($0) })
    }
}
