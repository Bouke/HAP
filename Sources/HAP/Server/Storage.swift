import Foundation

public protocol Storage: class {
    func read() throws -> Data
    func write(_: Data) throws
}

public class FileStorage: Storage {
    let fileURL: URL

    /// Creates a new instance that will store the device configuration
    /// at the given file path.
    ///
    /// - Parameter filename: path to the file
    public init(filename: String) {
        fileURL = URL(fileURLWithPath: filename)
    }

    public func read() throws -> Data {
        return try Data(contentsOf: fileURL, options: [])
    }

    public func write(_ newValue: Data) throws {
        try newValue.write(to: fileURL)
    }
}

public class MemoryStorage: Storage {
    var memory = Data()

    public func read() throws -> Data {
        return memory
    }

    public func write(_ newValue: Data) throws {
        memory = newValue
    }
}
