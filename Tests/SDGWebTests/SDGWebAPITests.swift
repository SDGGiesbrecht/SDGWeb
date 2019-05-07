/*
 SDGWebAPITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization
import SDGCalendar
import SDGWeb
import SDGWebLocalizations

import SDGLocalizationTestUtilities
import SDGXCTestUtilities

class SDGWebAPITests : TestCase {

    func testCopyright() {
        XCTAssert(¬copyrightDates(yearFirstPublished: CalendarDate.gregorianNow().gregorianYear).contains("–"))
        XCTAssert(copyrightDates(yearFirstPublished: 2000).contains(CalendarDate.gregorianNow().gregorianYear.inEnglishDigits()))
    }

    func testLocalized() throws {
        try generate(forMock: "Localized", localization: DoubleLocalization.self)
    }

    func testNoColon() {
        expectErrorGenerating(forMock: "No Colon", localization: SingleLocalization.self)
    }

    func testNoCSS() {
        #if !os(Linux) // Foundation fails to error on Linux.
        expectErrorGenerating(forMock: "No CSS", localization: SingleLocalization.self)
        #endif
    }

    func testNoFrame() {
        expectErrorGenerating(forMock: "No Frame", localization: SingleLocalization.self)
    }

    func testNoMetadata() {
        expectErrorGenerating(forMock: "No Metadata", localization: SingleLocalization.self)
    }

    func testNoTitle() {
        expectErrorGenerating(forMock: "No Title", localization: SingleLocalization.self)
    }

    func testRightToLeft() throws {
        try generate(forMock: "Right‐to‐Left", localization: RightToLeftLocalization.self)
    }

    func testRepositoryStructure() {
        _ = RepositoryStructure()
    }

    func testSiteError() {
        struct StandInError : PresentableError {
            func presentableDescription() -> StrictString {
                return "[...]"
            }
        }
        let errors: [SiteError] = [
            .templateLoadingError(page: "[...]", systemError: StandInError()),
            .noMetadata(page: "[...]"),
            .metadataMissingColon(line: "[...]"),
            .missingTitle(page: "[...]"),
            .pageSavingError(page: "[...]", systemError: StandInError()),
            .cssCopyingError(systemError: StandInError()),
            .resourceCopyingError(systemError: StandInError())
        ]
        for index in errors.indices {
            let error = errors[index]
            testCustomStringConvertibleConformance(of: error, localizations: InterfaceLocalization.self, uniqueTestName: index.inDigits(), overwriteSpecificationInsteadOfFailing: false)
        }
    }

    func testUnknownLocalization() throws {
        try generate(forMock: "Unknown Localization", localization: UnknownLocalization.self)
    }

    func testUnlocalized() throws {
        try generate(forMock: "Unlocalized", localization: SingleLocalization.self)
    }
}
