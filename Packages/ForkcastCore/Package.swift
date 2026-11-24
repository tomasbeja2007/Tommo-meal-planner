// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ForkcastCore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "ForkcastCore", targets: ["ForkcastCore"])
    ],
    targets: [
        .target(
            name: "ForkcastCore",
            path: "Sources/ForkcastCore",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "ForkcastCoreTests",
            dependencies: ["ForkcastCore"],
            path: "Tests/ForkcastCoreTests"
        )
    ]
)
