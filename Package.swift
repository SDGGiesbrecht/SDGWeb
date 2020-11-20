// swift-tools-version:5.3

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
      from: Version(6, 2, 0)
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

    .target(
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

import Foundation

if ProcessInfo.processInfo.environment["TARGETING_TVOS"] == "true" {
  // #workaround(xcodebuild -version 12.2, Tool targets don’t work on tvOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.name.hasPrefix("generate") })
}

if ProcessInfo.processInfo.environment["TARGETING_IOS"] == "true" {
  // #workaround(xcodebuild -version 12.2, Tool targets don’t work on iOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.name.hasPrefix("generate") })
}

if ProcessInfo.processInfo.environment["TARGETING_WATCHOS"] == "true" {
  // #workaround(xcodebuild -version 12.2, Test targets don’t work on watchOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.isTest })
  // #workaround(xcodebuild -version 12.2, Tool targets don’t work on watchOS.) @exempt(from: unicode)
  package.targets.removeAll(where: { $0.name.hasPrefix("generate") })
}

// Windows Tests (Generated automatically by Workspace.)
import Foundation
if ProcessInfo.processInfo.environment["TARGETING_WINDOWS"] == "true" {
  var tests: [Target] = []
  var other: [Target] = []
  for target in package.targets {
    if target.type == .test {
      tests.append(target)
    } else {
      other.append(target)
    }
  }
  package.targets = other
  package.targets.append(
    contentsOf: tests.map({ test in
      return .target(
        name: test.name,
        dependencies: test.dependencies,
        path: test.path ?? "Tests/\(test.name)",
        exclude: test.exclude,
        sources: test.sources,
        publicHeadersPath: test.publicHeadersPath,
        cSettings: test.cSettings,
        cxxSettings: test.cxxSettings,
        swiftSettings: test.swiftSettings,
        linkerSettings: test.linkerSettings
      )
    })
  )
  package.targets.append(
    .target(
      name: "WindowsTests",
      dependencies: tests.map({ Target.Dependency.target(name: $0.name) }),
      path: "Tests/WindowsTests"
    )
  )
}
// End Windows Tests
