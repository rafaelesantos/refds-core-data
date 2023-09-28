// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RefdsCoreData",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "RefdsCoreData",
            targets: ["RefdsCoreData"]),
    ],
    dependencies: [
        .package(url: "https://github.com/refdsenterprise/refds-core.git", branch: "main")
    ],
    targets: [
        .target(
            name: "RefdsCoreData",
            dependencies: [
                .product(
                    name: "RefdsCore",
                    package: "refds-core")
            ]),
    ]
)
