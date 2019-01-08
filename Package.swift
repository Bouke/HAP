// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "HAP",
    products: [
        .library(name: "HAP", targets: ["HAP"]),
        .executable(name: "hap-server", targets: ["hap-server"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Bouke/CLibSodium.git", from: "1.0.0"),
        .package(url: "https://github.com/Bouke/SRP.git", from: "3.0.1"),
        .package(url: "https://github.com/Bouke/HKDF.git", from: "3.0.1"),
        .package(url: "https://github.com/knly/Evergreen.git", .branch("swift4")),
        .package(url: "https://github.com/Bouke/Kitura-net.git", from: "1.7.0"),
        .package(url: "https://github.com/IBM-Swift/BlueSocket.git", from: "0.12.90"),
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "0.8.27"),
        .package(url: "https://github.com/crossroadlabs/Regex.git", from: "1.1.0"),
    ],
    targets: [
        .target(name: "CQRCode"),
        .target(name: "HAP", dependencies: ["SRP", "Cryptor", "Evergreen", "HKDF", "Kitura-net", "Regex", "Socket", "CQRCode"]),
        .target(name: "hap-server", dependencies: ["HAP", "Evergreen"]),
        .testTarget(name: "HAPTests", dependencies: ["HAP"]),
    ],
    swiftLanguageVersions: [4]
)

#if os(Linux)
    package.dependencies.append(.package(url: "https://github.com/Bouke/NetService.git", from: "0.5.0"))
    package.targets.first(where: { $0.name == "HAP" })!.dependencies.append("NetService")
#endif
