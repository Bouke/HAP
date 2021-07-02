// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "HAP",
    platforms: [
        .macOS(.v11),
    ],
    products: [
        .library(name: "HAP", targets: ["HAP"]),
        .executable(name: "hap-demo", targets: ["hap-demo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Bouke/SRP.git", from: "3.2.0"),
        .package(url: "https://github.com/crossroadlabs/Regex.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.13.0"),
        .package(url: "https://github.com/apple/swift-log.git", Version("0.0.0") ..< Version("2.0.0")),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "1.1.0"),
    ],
    targets: [
        .target(name: "CQRCode"),
        .target(name: "COperatingSystem"),
        .target(name: "HTTP",
                dependencies: [
                    .product(name: "NIO", package: "swift-nio"),
                    .product(name: "NIOHTTP1", package: "swift-nio"),
                    .product(name: "NIOFoundationCompat", package: "swift-nio"),
                    "COperatingSystem",
                ]),
        .target(name: "HAP",
                dependencies: [
                    "SRP",
                    .product(name: "Logging", package: "swift-log"),
                    "Regex",
                    "CQRCode",
                    "HTTP",
                    .product(name: "Crypto", package: "swift-crypto"),
                ]),
        .target(name: "hap-demo",
                dependencies: [
                    "HAP",
                    .product(name: "Logging", package: "swift-log")
                ]),
        .testTarget(name: "HAPTests", dependencies: ["HAP"]),
    ]
)

#if os(macOS)
    package.products.append(.executable(name: "hap-update", targets: ["HAPUpdate"]))
    package.targets.append(.target(name: "HAPUpdate"))
#endif

#if os(Linux)
    package.dependencies.append(.package(url: "https://github.com/Bouke/NetService.git", from: "0.7.0"))
    package.targets.first(where: { $0.name == "HAP" })!.dependencies.append("NetService")
#endif
