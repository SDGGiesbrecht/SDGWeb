/*
 Workspace.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration._applySDGDefaults()

configuration.documentation.currentVersion = Version(6, 1, 2)

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
