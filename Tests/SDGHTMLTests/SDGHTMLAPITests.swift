/*
 SDGHTMLAPITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

import SDGHTML

import SDGXCTestUtilities

class SDGHTMLAPITests : TestCase {

    func testEscaping() {
        XCTAssertFalse(HTML.escapeTextForCharacterData("<").contains("<"))
        XCTAssertFalse(HTML.escapeTextForAttribute("\u{22}").contains("\u{22}"))
    }

    func testPercentEncoding() {
        XCTAssertEqual(HTML.percentEncodeURLPath("Ελληνικό κείμενο"), "Ελληνικό%20κείμενο")
    }
}
