// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftExtensions",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftExtensions",
            targets: ["SwiftExtensions"])
    ],
    targets: [
        .target(
            name: "SwiftExtensions",
            path: "Sources"),
        .testTarget(
            name: "SwiftExtensionsTests",
            dependencies: ["SwiftExtensions"],
            path: "Tests")
    ]
)
