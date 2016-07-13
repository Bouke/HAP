import PackageDescription

let package = Package(
    name: "HAP",
    targets: [
        Target(name: "CommonCrypto"),
        Target(name: "Bignum"),
        Target(name: "SRP", dependencies: ["CommonCrypto", "Bignum"]),
        Target(name: "hap-server", dependencies: ["HTTP", "SRP"]),
        Target(name: "hap-browser"),
    ],
    dependencies: [
        .Package(url: "../CLibSodium", majorVersion: 1, minor: 0),
        .Package(url: "../COpenSSL", majorVersion: 1, minor: 0),
        .Package(url: "../CSRP", majorVersion: 1, minor: 0),
        .Package(url: "../CCommonCrypto", majorVersion: 1, minor: 0),
    ]
)
