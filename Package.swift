// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyCore",
    platforms: [.iOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftyCore",
            //type: .dynamic,
            targets: ["SwiftyCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "3.1.9"))
        .package(url: "https://github.com/NordicSemiconductor/IOS-Pods-DFU-Library", .upToNextMajor(from: "4.8.0"))
        .package(url: "https://github.com/weichsel/ZIPFoundation", .exact("0.9.11"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyCore",
            dependencies: ["ZIPFoundation", "NordicDFU"]),
        .testTarget(
            name: "SwiftyCoreTests",
            dependencies: ["SwiftyCore"]),
    ]
)
