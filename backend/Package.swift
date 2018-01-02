// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "backend",
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.0.0"),
        .package(url: "https://github.com/OpenKitten/MongoKitten.git", from: "4.0.0")    ],
    targets: [
        .target(
            name: "backend",
            dependencies: [
                "HeliumLogger",
                "Kitura",
                "MongoKitten"
            ]
        ),
        ]
)

