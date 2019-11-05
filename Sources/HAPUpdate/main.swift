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
    try Inspector.inspect(source: sourceURL, target: "Sources/HAP/Base/Generated.swift")
} catch {
    print("Couldn't update: \(error)")
}
