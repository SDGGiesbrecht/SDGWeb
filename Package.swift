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

/// #workaround(No documentation yet.)
let package = Package(
    name: "SDGWeb",
    products: [
        /// #workaround(No documentation yet.)
        .library(name: "SDGWeb", targets: ["SDGWeb"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .upToNextMinor(from: Version(0, 12, 0)))
    ],
    targets: [
        // Products

        /// #workaround(No documentation yet.)
        .target(name: "SDGWeb", dependencies: [
            "SDGWebLocalizations",
            .product(name: "SDGControlFlow", package: "SDGCornerstone"),
            .product(name: "SDGLogic", package: "SDGCornerstone"),
            .product(name: "SDGMathematics", package: "SDGCornerstone"),
            .product(name: "SDGCollections", package: "SDGCornerstone"),
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGCalendar", package: "SDGCornerstone")
            ]),

        // Internal

        .target(name: "SDGWebLocalizations", dependencies: [
            .product(name: "SDGLocalization", package: "SDGCornerstone")
            ]),

        .testTarget(name: "SDGWebTests", dependencies: [
            "SDGWeb",
            "SDGWebLocalizations",
            .product(name: "SDGText", package: "SDGCornerstone"),
            .product(name: "SDGLocalization", package: "SDGCornerstone"),
            .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
            ])
    ]
)
