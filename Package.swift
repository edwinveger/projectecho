// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProjectEcho",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "AppData", targets: ["AppData"]),
        .library(name: "AppDomain", targets: ["AppDomain"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "FFTFeature", targets: ["FFTFeature"]),
        .executable(name: "Sniffer", targets: ["Sniffer"])
    ],
    dependencies: [
        .package(url: "https://github.com/AudioKit/AudioKitEX",        from: "5.6.0"),
        .package(url: "https://github.com/AudioKit/AudioKitUI", exact: "0.3.5"),
        .package(url: "https://github.com/AudioKit/SoundpipeAudioKit", from: "5.6.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "AppData",
            dependencies: ["AppDomain", "EstimoteUWB"]
        ),
        .target(
            name: "AppDomain",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "AppDomain",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .binaryTarget(
            name: "EstimoteProximity",
            path: "Sources/EstimoteProximitySDK.xcframework"
        ),
        .binaryTarget(
            name: "EstimoteUWB",
            path: "Sources/EstimoteUWB.xcframework"
        ),
        .target(
            name: "FFTFeature",
            dependencies: [
                .product(name: "AudioKitUI", package: "AudioKitUI"),
                .product(name: "AudioKitEX", package: "AudioKitEX"),
                .product(name: "SoundpipeAudioKit", package: "SoundpipeAudioKit"),
            ]
        ),
        .executableTarget(
            name: "Sniffer"
        ),
        .testTarget(
            name: "AppDataTests",
            dependencies: ["AppData"]
        ),
    ]
)
