/*
 SDGWebAPITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization
import SDGCalendar

import SDGWebLocalizations
import SDGHTML
import SDGWeb

import XCTest

import SDGLocalizationTestUtilities
import SDGXCTestUtilities

class SDGWebAPITests : TestCase {

    func testCopyright() {
        XCTAssert(¬copyrightDates(yearFirstPublished: CalendarDate.gregorianNow().gregorianYear).contains("–"))
        XCTAssert(copyrightDates(yearFirstPublished: 2000).contains(CalendarDate.gregorianNow().gregorianYear.inEnglishDigits()))
    }

    func testInvalidHTML() {
        expectErrorGenerating(forMock: "Invalid HTML", localization: SingleLocalization.self)
    }

    func testLocalized() throws {
        for localization in InterfaceLocalization.allCases {
            try LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                try generate(forMock: "Localized", localization: DoubleLocalization.self)
            }
        }
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

    func testPoorHTML() throws {
        try generate(forMock: "Poor HTML", localization: SingleLocalization.self, expectValidationFailure: true)
    }

    func testRedirect() throws {
        try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { url in
            let redirectFile = Redirect(target: "../").contents
            try redirectFile.save(to: url.appendingPathComponent("Redirect.html"))
            let warnings = Site<InterfaceLocalization>.validate(site: url)
            XCTAssert(warnings.isEmpty, "\(warnings)")
        }
    }

    func testRepositoryStructure() {
        _ = RepositoryStructure()
    }

    func testRightToLeft() throws {
        try generate(forMock: "Right‐to‐Left", localization: RightToLeftLocalization.self)
    }

    struct StandInError : PresentableError {
        func presentableDescription() -> StrictString {
            return "[...]"
        }
    }
    func testSiteError() {
        let errors: [SiteGenerationError] = [
            .foundationError(StandInError()),
            .noMetadata(page: "[...]"),
            .metadataMissingColon(line: "[...]"),
            .missingTitle(page: "[...]")
        ]
        for index in errors.indices {
            let error = errors[index]
            testCustomStringConvertibleConformance(of: error, localizations: InterfaceLocalization.self, uniqueTestName: index.inDigits(), overwriteSpecificationInsteadOfFailing: false)
        }
    }
    func testSiteValidationError() {
        let parseFailure: SyntaxError
        switch DocumentSyntax.parse(source: "html>") {
        case .failure(let error):
            parseFailure = error
        case .success:
            XCTFail("Should not have parsed successfully.")
            return
        }
        let errors: [SiteValidationError] = [
            .foundationError(StandInError()),
            .syntaxError(parseFailure)
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
        for localization in InterfaceLocalization.allCases {
            try LocalizationSetting(orderOfPrecedence: [localization.code]).do {
                try generate(forMock: "Unlocalized", localization: SingleLocalization.self)
            }
        }
    }
}
