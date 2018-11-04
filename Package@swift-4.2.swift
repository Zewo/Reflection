// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Reflection",
    products: [
        .library(name: "Reflection", targets: ["Reflection"]),
    ],
    targets: [
        .target(
            name: "Reflection", 
            dependencies: []
        )
    ],
    swiftLanguageVersions: [.v3, .v4, .v4_2]
)
