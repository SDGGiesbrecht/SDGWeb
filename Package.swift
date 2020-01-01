// swift-tools-version:5.1

/*
 Package.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// #example(1, readMe🇨🇦EN)
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
///
/// ### Example Usage
///
/// ```swift
/// let mock = RepositoryStructure(
///   root: URL(fileURLWithPath: #file)
///     .deletingLastPathComponent()
///     .deletingLastPathComponent()
///     .appendingPathComponent("Mock Projects/\(mockName)")
/// )
///
/// let site = Site<L>(
///   repositoryStructure: mock,
///   domain: UserFacing<StrictString, L>({ _ in return "http://example.com" }),
///   localizationDirectories: UserFacing<StrictString, L>({ localization in
///     return localization.icon ?? StrictString(localization.code)
///   }),
///   author: UserFacing<ElementSyntax, L>({ _ in
///     return .author("John Doe", language: InterfaceLocalization.englishCanada)
///   }),
///   pageProcessor: Processor(),
///   reportProgress: { _ in }
/// )
///
/// try site.generate().get()
/// let warnings = site.validate()
/// ```
let package = Package(
  name: "SDGWeb",
  products: [
    // @documentation(SDGWeb)
    /// The API to set up a generator.
    .library(name: "SDGWeb", targets: ["SDGWeb"]),

    // @documentation(SDGHTML)
    /// General utilities for working with HTML source.
    .library(name: "SDGHTML", targets: ["SDGHTML"]),

    // @documentation(SDGCSS)
    /// General utilities for working with CSS source.
    .library(name: "SDGCSS", targets: ["SDGCSS"])
  ],
  dependencies: [
    .package(url: "https://github.com/SDGGiesbrecht/SDGCornerstone", from: Version(4, 0, 0))
  ],
  targets: [
    // Products

    // #documentation(SDGWeb)
    /// The API to set up a generator.
    .target(
      name: "SDGWeb",
      dependencies: [
        "SDGWebLocalizations",
        "SDGHTML",
        "SDGCSS",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGMathematics", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGCalendar", package: "SDGCornerstone")
      ]
    ),

    // #documentation(SDGHTML)
    /// General utilities for working with HTML source.
    .target(
      name: "SDGHTML",
      dependencies: [
        "SDGWebLocalizations",
        .product(name: "SDGControlFlow", package: "SDGCornerstone"),
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGMathematics", package: "SDGCornerstone"),
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone")
      ]
    ),

    // #documentation(SDGCSS)
    /// General utilities for working with CSS source.
    .target(
      name: "SDGCSS",
      dependencies: [
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone")
      ]
    ),

    // Internal

    .target(
      name: "SDGWebLocalizations",
      dependencies: [
        .product(name: "SDGLocalization", package: "SDGCornerstone")
      ]
    ),

    // Resource Generation

    .target(
      name: "generate‐entity‐list",
      dependencies: [
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone")
      ]
    ),

    // Tests

    .testTarget(
      name: "SDGWebTests",
      dependencies: [
        "SDGHTML",
        "SDGWeb",
        "SDGWebLocalizations",
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGCalendar", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
      ]
    ),

    .testTarget(
      name: "SDGHTMLTests",
      dependencies: [
        "SDGWebLocalizations",
        "SDGHTML",
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone")
      ]
    )
  ]
)

// #workaround(workspace 0.27.1, Causes Xcode executable/scheme issues for iOS.)
#if os(macOS)
  package.targets.removeAll(where: { $0.name == "generate‐entity‐list" })
#endif
