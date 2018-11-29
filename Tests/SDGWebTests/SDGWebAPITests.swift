/*
 SDGWebAPITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

import SDGXCTestUtilities

import SDGWeb

class SDGWebAPITests : TestCase {

    func testUnlocalized() throws {
        enum Localization : String, InputLocalization {
            case english = "en"
            static var fallbackLocalization = Localization.english
        }
        struct Processor : PageProcessor {
            func process(pageTemplate: inout StrictString, title: StrictString, content: StrictString, siteRoot: StrictString, relativePath: StrictString) {
                pageTemplate.replaceMatches(for: "[*content*]", with: content)
            }
        }
        let mock = RepositoryStructure(root: URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("Mock Projects/Unlocalized"))
        print(mock.root)
        let site = Site<Localization>(
            repositoryStructure: mock,
            domain: UserFacing<StrictString, Localization>({ localization in
                switch localization {
                case .english:
                    return "http://example.com"
                }
            }),
            pageProcessor: Processor(),
            reportProgress: { _ in })
        try site.generate()
    }
}
