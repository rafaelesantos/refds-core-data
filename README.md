# Refds Core Data

RefdsCoreData é uma biblioteca Swift que simplifica a integração do Core Data em seus projetos utilizando Swift Package Manager (SPM). Com apenas algumas linhas de código, você pode começar a utilizar o Core Data em seu aplicativo de forma rápida e eficiente.

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
