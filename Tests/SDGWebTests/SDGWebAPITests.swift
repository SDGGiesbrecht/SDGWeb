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
import SDGWeb

import SDGXCTestUtilities

class SDGWebAPITests : TestCase {

    func testNoFrame() {
        expectErrorGenerating(forMock: "No Frame", localization: SingleLocalization.self)
    }

    func testNoTitle() {
        expectErrorGenerating(forMock: "No Title", localization: SingleLocalization.self)
    }

    func testUnlocalized() throws {
        try generate(forMock: "Unlocalized", localization: SingleLocalization.self)
    }
}
