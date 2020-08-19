// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "HAP",
    // todo: drop 10.15 requirement from crypto fork
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "HAP", targets: ["HAP"]),
        .executable(name: "hap-demo", targets: ["hap-demo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Bouke/SRP.git", from: "3.1.0"),
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "1.0.21"),
        .package(url: "https://github.com/crossroadlabs/Regex.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.13.0"),
        .package(url: "https://github.com/apple/swift-log.git", Version("0.0.0") ..< Version("2.0.0")),
        .package(url: "https://github.com/Bouke/swift-crypto.git", from: "1.0.2"),
    ],
    targets: [
        .target(name: "CQRCode"),
        .target(name: "COperatingSystem"),
        .target(name: "HTTP", dependencies: ["NIO", "NIOHTTP1", "NIOFoundationCompat", "COperatingSystem"]),
        .target(name: "HAP", dependencies: ["SRP", "Cryptor", "Logging", "Regex", "CQRCode", "HTTP", "Crypto"]),
        .target(name: "hap-demo", dependencies: ["HAP", "Logging"]),
        .testTarget(name: "HAPTests", dependencies: ["HAP"]),
    ]
)

#if os(macOS)
    package.products.append(.executable(name: "hap-update", targets: ["HAPUpdate"]))
    package.targets.append(.target(name: "HAPUpdate", dependencies: []))
#endif

#if os(Linux)
    package.dependencies.append(.package(url: "https://github.com/Bouke/NetService.git", from: "0.7.0"))
    package.targets.first(where: { $0.name == "HAP" })!.dependencies.append("NetService")
#endif
