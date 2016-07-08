import PackageDescription

let package = Package(
    name: "HAP",
    targets: [
        Target(name: "hap-server", dependencies: ["HTTP", "SRP"]),
        Target(name: "hap-browser"),
    ],
    dependencies: [
        .Package(url: "../CLibSodium", majorVersion: 1, minor: 0),
        .Package(url: "../COpenSSL", majorVersion: 1, minor: 0),
        .Package(url: "../CSRP", majorVersion: 1, minor: 0),
        .Package(url: "../CommonCrypto", versions: Version("0.1.4")!..<Version("0.2.0")!),
    ]
)
