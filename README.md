# Refds Core Data

[![CI](https://github.com/rafaelesantos/refds-core-data/actions/workflows/swift.yml/badge.svg)](https://github.com/rafaelesantos/refds-core-data/actions/workflows/swift.yml)

RefdsCoreData is a Swift library that simplifies the integration of Core Data into your projects using Swift Package Manager (SPM). With just a few lines of code, you can start using Core Data in your application quickly and efficiently.

## Installation

Add this project to your `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .package(url: "https://github.com/rafaelesantos/refds-core-data.git", branch: "main")
    ],
    targets: [
        .target(
            name: "YourProject",
            dependencies: [
                .product(
                    name: "RefdsUI",
                    package: "refds-core-data"),
            ]),
    ]
)
```
