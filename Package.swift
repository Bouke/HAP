import PackageDescription

let package = Package(
    name: "HAP",
    targets: [
        Target(name: "HAP", dependencies: ["HTTP"]),
        Target(name: "hap-server", dependencies: ["HAP"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Bouke/CLibSodium.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/CommonCrypto.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/SRP.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/HKDF.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/Evergreen.git", majorVersion: 0),
    ]
)
