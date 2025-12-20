// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ForeFlightKML",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ForeFlightKML",
            targets: ["ForeFlightKML"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/florianreinhart/Geodesy", .upToNextMajor(from: "0.2.2")),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.0")
    ],
    targets: [
        .target(
            name: "ForeFlightKML",
            dependencies: [
                .product(name: "Geodesy", package: "Geodesy"),
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
