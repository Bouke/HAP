import PackageDescription

let package = Package(
    name: "HAP",
    targets: [
        Target(name: "HTTP", dependencies: ["Evergreen"]),
        Target(name: "HKDF", dependencies: ["CommonCrypto"]),
        Target(name: "SRP", dependencies: ["CommonCrypto", "Bignum"]),
        Target(name: "HAP", dependencies: ["HKDF", "HTTP", "SRP", "CryptoSwift", "Evergreen"]),
        Target(name: "hap-server", dependencies: ["HAP", "Evergreen"]),
        Target(name: "hap-browser"),
    ],
    dependencies: [
        .Package(url: "https://github.com/Bouke/CLibSodium.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/COpenSSL.git", majorVersion: 1),
        .Package(url: "https://github.com/Bouke/CCommonCrypto.git", majorVersion: 1),
    ]
)
