// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MCVision",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "MCVision",
            targets: ["MCVision"]),
    ],
    targets: [
        .target(
            name: "MCVision"
        )
    ]
)
