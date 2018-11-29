/*
 SimpleProcessor.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGWeb

struct Processor : PageProcessor {
    func process(pageTemplate: inout StrictString, title: StrictString, content: StrictString, siteRoot: StrictString, relativePath: StrictString) {
        pageTemplate.replaceMatches(for: "[*content*]", with: content)
    }
}
