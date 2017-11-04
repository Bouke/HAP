import Foundation

public protocol Storage: class {
    subscript(key: String) -> Data? { get set }
    func removeAll() throws
    var keys: [String] { get }
}

public class PrefixedKeyStorage: Storage {
    let prefix: String
    let backing: Storage
    init(prefix: String, backing: Storage) {
        self.prefix = prefix
        self.backing = backing
    }
    public subscript(key: String) -> Data? {
        get {
            return backing["\(prefix)\(key)"]
        }
        set {
            backing["\(prefix)\(key)"] = newValue
        }
    }
    public func removeAll() throws {
        keys.forEach {
            backing["\(prefix)\($0)"] = nil
        }
    }
    public var keys: [String] {
        return backing.keys
            .filter { $0.hasPrefix(prefix) }
            .map { $0.replacingOccurrences(of: prefix, with: "") }
    }
}

public class FileStorage: Storage {
    public enum Error: Swift.Error {
        case couldNotCreateDirectory
    }

    let path: String

    public init(path: String) throws {
        if !FileManager.default.directoryExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                throw Error.couldNotCreateDirectory
            }
        }
        self.path = path
    }

    public subscript(key: String) -> Data? {
        get {
            let entityPath = URL(fileURLWithPath: path).appendingPathComponent(key)
            guard let data = try? Data(contentsOf: entityPath, options: []) else {
                return nil
            }
            return data
        }
        set {
            let entityPath = URL(fileURLWithPath: path).appendingPathComponent(key)
            do {
                if let newValue = newValue {
                    try newValue.write(to: entityPath)
                } else if FileManager.default.fileExists(atPath: entityPath.absoluteString) {
                    try FileManager.default.removeItem(at: entityPath)
                }
            } catch {
                fatalError("Could not write to storage: \(error)")
            }
        }
    }

    public func removeAll() throws {
        for file in try FileManager.default.contentsOfDirectory(atPath: path) {
            try FileManager.default.removeItem(atPath: "\(path)/\(file)")
        }
    }

    public var keys: [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            fatalError("Could not get keys: \(error)")
        }
    }
}

public class MemoryStorage: Storage {
    var memory = [String: Data]()
    public subscript(key: String) -> Data? {
        get {
            return memory[key]
        }
        set {
            memory[key] = newValue
        }
    }
    public func removeAll() throws {
        memory = [:]
    }
    public var keys: [String] {
        return Array(memory.keys)
    }
}
