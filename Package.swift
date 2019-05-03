// swift-tools-version:5.0

/*
 Package.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

/// SDGWeb provides tools for generating websites.
///
/// > [כְּשִׁמְךָ אֱלֹהִים כְּן תְּהלָּתְךָ עַל־קַצְוֵי־אֶרֶץ׃](https://www.biblegateway.com/passage/?search=Psalm+48&version=WLC;NIV)
/// >
/// > [Like your name, O God, your praise reaches to the ends of the earth.](https://www.biblegateway.com/passage/?search=Psalm+48&version=WLC;NIV)
/// >
/// > ―sons of קורח/Koraẖ
///
/// ### Features:
///
/// - Sites are constructed from simple templates.
/// - Customizable template processing in Swift.
/// - Supports localized websites.
let package = Package(
    name: "SDGWeb",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .watchOS(.v4),
        .tvOS(.v11)
    ],
    products: [
        // @documentation(SDGWeb)
        /// The API to set up a generator.
        .library(name: "SDGWeb", targets: ["SDGWeb"]),

        // @documentation(SDGHTML)
        /// General utilities for working with HTML source.
        .library(name: "SDGHTML", targets: ["SDGHTML"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", .upToNextMinor(from: Version(0, 17, 0)))
    ],
    targets: [
        // Products

        // #documentation(SDGWeb)
        /// The API to set up a generator.
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

        // @documentation(SDGHTML)
        /// General utilities for working with HTML source.
        .target(name: "SDGHTML", dependencies: [
            .product(name: "SDGText", package: "SDGCornerstone")
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
            .product(name: "SDGCalendar", package: "SDGCornerstone"),
            .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
            ]),

        .testTarget(name: "SDGHTMLTests", dependencies: [
            "SDGHTML",
            .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
            ])
    ]
)
