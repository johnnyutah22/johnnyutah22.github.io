// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "JohnnyUtahMobile",
    products: [
        .executable(
            name: "JohnnyUtahMobile",
            targets: ["JohnnyUtahMobile"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.7.0"),
        .package(url: "https://github.com/Ze0nC/SwiftPygmentsPublishPlugin", .branch("master")),
        .package(url: "https://github.com/alexito4/ReadingTimePublishPlugin.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "JohnnyUtahMobile",
            dependencies: ["Publish", "SwiftPygmentsPublishPlugin", "ReadingTimePublishPlugin"]
        )
    ]
)
