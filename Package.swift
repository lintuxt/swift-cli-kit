// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "swift-cli-kit",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "CLIKit", targets: ["CLIKit"]),
    ],
    targets: [
        .target(name: "CLIKit"),
        .testTarget(name: "CLIKitTests", dependencies: ["CLIKit"]),
    ]
)
