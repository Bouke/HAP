import Foundation

var sourceURL: URL

if CommandLine.argc > 1 {
    let arg = CommandLine.arguments[1]
    sourceURL = URL(fileURLWithPath: arg)
} else {
    let path = "/System/Library/PrivateFrameworks/HomeKitDaemon.framework"
    guard let framework = Bundle(path: path) else {
        print("No HomeKitDaemon private framework found")
        exit(1)
    }
    guard let plistUrl = framework.url(forResource: "plain-metadata", withExtension: "config") else {
        print("Resource plain-metadata.config not found in HomeKitDaemon.framework")
        exit(1)
    }
    sourceURL = plistUrl
}
do {
    print("Generating from \(sourceURL)")

    let base = "Sources/HAP/Base"
    if !FileManager.default.directoryExists(atPath: base) {
        print("Expected existing directory at `\(base)`")
        exit(1)
    }

    let target = "\(base)/Predefined"
    if FileManager.default.directoryExists(atPath: target) {
        try FileManager.default.removeItem(atPath: target)
    }
    try FileManager.default.createDirectory(atPath: target, withIntermediateDirectories: false, attributes: nil)
    try Inspector.inspect(source: sourceURL, target: target)
} catch {
    print("Couldn't update: \(error)")
}

extension FileManager {
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
