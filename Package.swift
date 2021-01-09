// swift-tools-version:5.3

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

for target in package.targets {
  var swiftSettings = target.swiftSettings ?? []
  defer { target.swiftSettings = swiftSettings }
  swiftSettings.append(contentsOf: [

    // Internal‐only:
    // #workaround(Swift 5.3.2, Web lacks Foundation.FileManager.)
    .define("PLATFORM_LACKS_FOUNDATION_FILE_MANAGER", .when(platforms: [.wasi])),
    // #workaround(Swift 5.3.2, Web lacks Foundation.ProcessInfo.)
    .define("PLATFORM_LACKS_FOUNDATION_PROCESS_INFO", .when(platforms: [.wasi])),
  ])
}

import Foundation

//if ProcessInfo.processInfo.environment["TARGETING_WEB"] == "true" {
  // #warning(Debugging.)
package.products.removeAll(where: { $0.name == "SDGWeb" })
package.targets.removeAll(where: { $0.name == "SDGWeb" })

  let target = package.targets.first(where: { $0.name == "SDGHTML" })
  target?.exclude = [
    "Syntax/Nodes/AttributesSyntax.swift",
    "Syntax/Nodes/AttributeSyntax.swift",
    "Syntax/Nodes/AttributeValueSyntax.swift",
    "Syntax/Nodes/ClosingTagSyntax.swift",
    "Syntax/Nodes/CommentSyntax.swift",
    "Syntax/Nodes/ContentSyntax.swift",
    "Syntax/Nodes/ContentSyntax+Factories.swift",
    "Syntax/Nodes/DocumentSyntax.swift",
    "Syntax/Nodes/DocumentSyntax+Factories.swift",
    "Syntax/Nodes/ElementContinuationSyntax.swift",
    "Syntax/Nodes/ElementSyntax.swift",
    "Syntax/Nodes/ElementSyntax+Factories.swift",
    "Syntax/Nodes/ListSyntax.swift",
    "Syntax/Nodes/ListSyntaxAttributeSyntax.swift",
    "Syntax/Nodes/ListSyntaxContentSyntax.swift",
    "Syntax/Nodes/OpeningTagSyntax.swift",
    "Syntax/Nodes/TextSyntax.swift",
    "Syntax/Nodes/TokenSyntax.swift",
    "Syntax/Protocols/AttributedSyntax.swift",
    //"Syntax/Protocols/ChildSet.swift",
    "Syntax/Protocols/ContainerSyntax.swift",
    "Syntax/Protocols/NamedSyntax.swift",
    "Syntax/Protocols/Syntax.swift",
    "Syntax/ContentSyntaxKind.swift",
    //"Syntax/HeadingLevel.swift",
    //"Syntax/SyntaxError.swift",
    "Syntax/SyntaxStorage.swift",
    "Syntax/SyntaxUnfolder.swift",
    "Syntax/SyntaxUnfolderContext.swift",
    "Syntax/SyntaxUnfolderError.swift",
    "Syntax/SyntaxUnfolderProtocol.swift",
    //"Syntax/TokenKind.swift",
    "Syntax/UnfoldingError.swift",
    //"Entities.swift",
    //"HTML.swift",
    "Localization.swift",
    //"TextDirection.swift",
  ]
  let impossibleTests = [
    "SDGHTMLTests",
    "SDGWebTests"
  ]
  package.targets.removeAll(where: { impossibleTests.contains($0.name) })
  package.targets.append(.testTarget(name: "DebuggingTests", dependencies: [
    "SDGWebLocalizations",
    "SDGCSS",
    "SDGHTML"
  ]))
//}

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
