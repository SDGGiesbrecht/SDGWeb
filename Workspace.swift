/*
 Workspace.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import WorkspaceConfiguration

let configuration = WorkspaceConfiguration()
configuration._applySDGDefaults()

configuration.documentation.currentVersion = Version(0, 0, 0)

configuration.documentation.projectWebsite = URL(string: "https://sdggiesbrecht.github.io/SDGWeb")!
configuration.documentation.documentationURL = URL(string: "https://sdggiesbrecht.github.io/SDGWeb")!
configuration.documentation.api.yearFirstPublished = 2018
configuration.documentation.repositoryURL = URL(string: "https://github.com/SDGGiesbrecht/SDGWeb")!

configuration.documentation.localizations = ["🇨🇦EN"]

configuration.documentation.readMe.shortProjectDescription["🇨🇦EN"] = "SDGWeb provides tools for generating websites."

// #warning(No quote yet.)
configuration.documentation.readMe.quotation = Quotation(original: "")
configuration.documentation.readMe.quotation?.translation["🇨🇦EN"] = ""
configuration.documentation.readMe.quotation?.link["🇨🇦EN"] = URL(string: "https://www.biblegateway.com/passage/?search=")!
configuration.documentation.readMe.quotation?.citation["🇨🇦EN"] = ""

configuration.documentation.readMe.featureList["🇨🇦EN"] = [
    // #workaround(No features yet.)
    ].joinedAsLines()

// #workaround(No examples yet.)
configuration.documentation.readMe.exampleUsage["🇨🇦EN"] = ""

configuration.continuousIntegration.skipSimulatorOutsideContinuousIntegration = true
configuration.documentation.api.encryptedTravisCIDeploymentKey = "#warning(No key yet.)"

configuration._applySDGOverrides()
configuration._validateSDGStandards()
