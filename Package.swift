// swift-tools-version:5.4

/*
 Package.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import PackageDescription

// #example(1, readMe🇨🇦EN) #example(2, conditions)
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
///   root:
///     sdgWebRepositoryRoot
///     .appendingPathComponent("Tests")
///     .appendingPathComponent("Mock Projects")
///     .appendingPathComponent(mockName)
/// )
///
/// let site = Site<L, Unfolder>(
///   repositoryStructure: mock,
///   siteRoot: UserFacing<URL, L>({ _ in return URL(string: "http://example.com")! }),
///   localizationDirectories: UserFacing<StrictString, L>({ localization in
///     return localization.icon ?? StrictString(localization.code)
///   }),
///   author: UserFacing<ElementSyntax, L>({ _ in
///     return .author("John Doe", language: InterfaceLocalization.englishCanada)
///   }),
///   reportProgress: { _ in }
/// )
///
/// try site.generate().get()
/// let warnings = site.validate()
/// ```
///
/// Some platforms lack certain features. The compilation conditions which appear throughout the documentation are defined as follows:
///
/// ```swift
/// .define("PLATFORM_LACKS_FOUNDATION_FILE_MANAGER", .when(platforms: [.wasi])),
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
    .library(name: "SDGCSS", targets: ["SDGCSS"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/SDGGiesbrecht/SDGCornerstone",
      from: Version(8, 0, 0)
    )
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
        .product(name: "SDGCalendar", package: "SDGCornerstone"),
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
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
      ]
    ),

    // #documentation(SDGCSS)
    /// General utilities for working with CSS source.
    .target(
      name: "SDGCSS",
      dependencies: [
        .product(name: "SDGCollections", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
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

    .executableTarget(
      name: "generate‐entity‐list",
      dependencies: [
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
      ]
    ),

    // Tests

    .testTarget(
      name: "SDGHTMLTests",
      dependencies: [
        "SDGWebLocalizations",
        "SDGHTML",
        .product(name: "SDGLogic", package: "SDGCornerstone"),
        .product(name: "SDGText", package: "SDGCornerstone"),
        .product(name: "SDGPersistence", package: "SDGCornerstone"),
        .product(name: "SDGLocalization", package: "SDGCornerstone"),
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
      ]
    ),

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
        .product(name: "SDGPersistenceTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGLocalizationTestUtilities", package: "SDGCornerstone"),
        .product(name: "SDGXCTestUtilities", package: "SDGCornerstone"),
      ]
    ),
  ]
)

for target in package.targets {
  var swiftSettings = target.swiftSettings ?? []
  defer { target.swiftSettings = swiftSettings }
  swiftSettings.append(contentsOf: [
    // #workaround(Swift 5.4.2, Web lacks Foundation.FileManager.)
    // @example(conditions)
    .define("PLATFORM_LACKS_FOUNDATION_FILE_MANAGER", .when(platforms: [.wasi])),
    // @endExample

    // Internal‐only:
    // #workaround(Swift 5.4.2, Web cannot handle long literals.)
    .define("PLATFORM_SUFFERS_LONG_LITERAL_BUG", .when(platforms: [.wasi])),
    // #workaround(Swift 5.4.2, Web lacks Foundation.ProcessInfo.)
    .define("PLATFORM_LACKS_FOUNDATION_PROCESS_INFO", .when(platforms: [.wasi])),
    // #workaround(Swift 5.4.2, Web lacks Foundation.URL.checkResourceIsReachable().)
    .define("PLATFORM_LACKS_FOUNDATION_URL_CHECK_RESOURCE_IS_REACHABLE", .when(platforms: [.wasi])),
    // #workaround(Swift 5.4.2, Web lacks Foundation.URL.init(fileURLWithPath).)
    .define("PLATFORM_LACKS_FOUNDATION_URL_INIT_FILE_URL_WITH_PATH", .when(platforms: [.wasi])),
    // #workaround(Swift 5.4.2, Web lacks Foundation.URLRequest.)
    .define("PLATFORM_LACKS_FOUNDATION_URL_REQUEST", .when(platforms: [.wasi, .android])),
    // #wokraround(SDGCornerstone 7.2.4, Windows line endings not supported by testFileConvertibleConformance.)
    .define("PLATFORM_LINE_ENDINGS_NOT_SUPPORTED_BY_SDG_CORNERSONE", .when(platforms: [.windows])),
    // #workaround(SDGCornerstone 7.2.4, Windows suffers unexplained segmentation faults.)
    .define("PLATFORM_SUFFERS_SEGMENTATION_FAULTS", .when(platforms: [.windows])),
  ])
}

#if os(Windows)
  // #workaround(Swift 5.4.2, Unable to build from Windows.)
  package.targets.removeAll(where: { $0.name == "generate‐entity‐list" })
#endif

import Foundation
if ProcessInfo.processInfo.environment["TARGETING_TVOS"] == "true" {
  // #workaround(xcodebuild -version 12.5.1, Tool targets don’t work on tvOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.type == .executable })
}

if ProcessInfo.processInfo.environment["TARGETING_IOS"] == "true" {
  // #workaround(xcodebuild -version 12.5.1, Tool targets don’t work on iOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.type == .executable })
}

if ProcessInfo.processInfo.environment["TARGETING_WATCHOS"] == "true" {
  // #workaround(xcodebuild -version 12.5.1, Tool targets don’t work on watchOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.type == .executable })
}
