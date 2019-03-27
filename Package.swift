// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mint",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "mint",
            targets: ["Mint"]),
        .library(
            name: "MintKit",
            targets: ["MintKit"]),
        ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/kareman/SwiftShell.git", from: "4.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.0.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Mint",
            dependencies: [
                "MintKit",
                "Rainbow",
                "SwiftShell",
                ]),
        .target(
            name: "MintKit",
            dependencies: [
                "SwiftShell",
                "Rainbow",
                "PathKit",
                "Utility"
                ]),
        .testTarget(
            name: "MintTests",
            dependencies: ["MintKit"]),
        ]
)
