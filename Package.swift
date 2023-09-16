// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProjectEcho",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "AppData", targets: ["AppData"]),
        .library(name: "AppDomain", targets: ["AppDomain"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AudioKit/AudioKitUI", exact: "0.3.5"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppData",
            dependencies: ["AppDomain"]
        ),
        .target(
            name: "AppDomain",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "AppDomain",
                .product(name: "AudioKitUI", package: "AudioKitUI")
            ]
        ),
        .testTarget(
            name: "AppDataTests",
            dependencies: ["AppData"]
        ),
    ]
)
