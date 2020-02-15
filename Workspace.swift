/*
 Workspace.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration._applySDGDefaults()

configuration.documentation.currentVersion = Version(5, 0, 1)

configuration.documentation.projectWebsite = URL(string: "https://sdggiesbrecht.github.io/SDGWeb")!
configuration.documentation.documentationURL = URL(
  string: "https://sdggiesbrecht.github.io/SDGWeb"
)!
configuration.documentation.api.yearFirstPublished = 2018
configuration.documentation.repositoryURL = URL(string: "https://github.com/SDGGiesbrecht/SDGWeb")!

configuration.documentation.localizations = ["🇨🇦EN"]

configuration.continuousIntegration.skipSimulatorOutsideContinuousIntegration = true

configuration._applySDGOverrides()
configuration._validateSDGStandards()

configuration.repository.ignoredPaths.insert("Tests/Mock Projects")

configuration.documentation.api.ignoredDependencies = [
  // Swift
  "Dispatch",
  "Foundation",
  "XCTest",

  // SDGCornerstone
  "SDGLogic",
  "SDGCalendar",
  "SDGCollections",
  "SDGCornerstoneLocalizations",
  "SDGLocalizationTestUtilities",
  "SDGLogic",
  "SDGMathematics",
  "SDGPersistence",
  "SDGPersistenceTestUtilities",
  "SDGTesting",
  "SDGText",
  "SDGXCTestUtilities"
]
