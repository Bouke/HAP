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
        .package(url: "https://github.com/Bouke/SRP.git", from: "3.0.0"),
        .package(url: "https://github.com/Bouke/HKDF.git", from: "3.0.0"),
        .package(url: "https://github.com/knly/Evergreen.git", .branch("swift4")),
        .package(url: "https://github.com/Bouke/Kitura-net.git", from: "1.7.0"),
        .package(url: "https://github.com/IBM-Swift/BlueSocket.git", from: "0.12.0"),
        .package(url: "https://github.com/IBM-Swift/BlueCryptor.git", from: "0.8.16"),
    ],
    targets: [
        .target(name: "HAP", dependencies: ["SRP", "Cryptor", "Evergreen", "HKDF", "Kitura-net", "Socket"]),
        .target(name: "hap-server", dependencies: ["HAP"]),
        .testTarget(name: "HAPTests", dependencies: ["HAP"]),
    ],
    swiftLanguageVersions: [4]
)

#if os(Linux)
    package.dependencies.append(.package(url: "https://github.com/Bouke/NetService.git", from: "0.3.0"))
    package.targets[0].dependencies.append("NetService")
#endif
