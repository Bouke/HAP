import PackageDescription

let package = Package(
    name: "HAP",
    targets: [
        Target(name: "HAP", dependencies: ["HTTPServer"]),
        Target(name: "hap-server", dependencies: ["HAP"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Bouke/CLibSodium.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/SRP.git", majorVersion: 2),
        .Package(url: "https://github.com/Bouke/HKDF.git", majorVersion: 2),
        .Package(url: "https://github.com/knly/Evergreen.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/Kitura-net.git", majorVersion: 1, minor: 7),
    ]
)

#if os(Linux)
    package.dependencies.append(.Package(url: "https://github.com/Bouke/NetService.git", majorVersion: 0, minor: 1))
#endif
