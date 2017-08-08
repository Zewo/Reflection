// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reflection",
    products: [
        .library(name: "Reflection", targets: ["Reflection"]),
    ],
    targets: [
        .target(name: "Reflection"),
        .testTarget(name: "ReflectionTests", dependencies: ["Reflection"]),
    ]
)
