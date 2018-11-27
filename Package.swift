// swift-tools-version:4.2

/*
 Package.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

let package = Package(
    name: "SDGWeb",
    products: [
        .library(name: "SDGWeb", targets: ["SDGWeb"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .upToNextMinor(from: Version(0, 12, 0)))
    ],
    targets: [
        .target(name: "SDGWeb", dependencies: []),
        .testTarget(name: "SDGWebTests", dependencies: [
            "SDGWeb",
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
            ])
    ]
)
