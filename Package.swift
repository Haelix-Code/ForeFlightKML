// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "ForeFlightKML",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "ForeFlightKML",
            targets: ["ForeFlightKML"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Haelix-Code/VincentySwift", .upToNextMinor(from: "0.0.1")),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "ForeFlightKML",
            dependencies: [
                .product(name: "Vincenty", package: "VincentySwift"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ForeFlightKMLTests",
            dependencies: ["ForeFlightKML"]
        ),
        .testTarget(
            name: "UserMapShapeTests",
            dependencies: ["ForeFlightKML"]
        )
    ]
)
