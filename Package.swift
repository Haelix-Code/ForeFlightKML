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
        .package(url: "https://github.com/florianreinhart/Geodesy", .upToNextMajor(from: "0.2.2"))
    ],
    targets: [
        .target(
            name: "ForeFlightKML",
            dependencies: [
                .product(name: "Geodesy", package: "Geodesy")
            ]
        ),
        .testTarget(
            name: "ForeFlightKMLTests",
            dependencies: ["ForeFlightKML"]
        ),
    ]
)
