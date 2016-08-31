import Foundation

public class FileStorage {
    public enum Error: Swift.Error {
        case couldNotCreateDirectory
    }

    let path: String

    public init(path: String) throws {
        if !FileManager.default.directoryExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw Error.couldNotCreateDirectory
            }
        }
        self.path = path
    }

    subscript(key: String) -> Data? {
        get {
            let entityPath = URL(fileURLWithPath: path).appendingPathComponent(key)
            guard let data = try? Data(contentsOf: entityPath, options: []) else {
                return nil
            }
            return data
        }
        set {
            let entityPath = URL(fileURLWithPath: path).appendingPathComponent(key)
            if let newValue = newValue {
                try! newValue.write(to: entityPath)
            } else {
                try! FileManager.default.removeItem(at: entityPath)
            }
        }
    }
}
