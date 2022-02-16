/*
 APITests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2022 Jeremy David Giesbrecht and the SDGWeb project contributors.

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

import SDGPersistenceTestUtilities
import SDGLocalizationTestUtilities
import SDGXCTestUtilities

class APITests: TestCase {

  func testCopyright() {
    #if !PLATFORM_SUFFERS_SEGMENTATION_FAULTS
      XCTAssert(
        ¬copyrightDates(yearFirstPublished: CalendarDate.gregorianNow().gregorianYear).contains("–")
      )
      XCTAssert(
        copyrightDates(yearFirstPublished: 2000).contains(
          CalendarDate.gregorianNow().gregorianYear.inEnglishDigits()
        )
      )
    #endif
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
    #if !os(Linux)  // Foundation fails to error on Linux.
      expectErrorGenerating(forMock: "No CSS", localization: SingleLocalization.self)
    #endif
  }

  func testNoMetadata() {
    expectErrorGenerating(forMock: "No Metadata", localization: SingleLocalization.self)
  }

  func testNoKeywords() {
    expectErrorGenerating(forMock: "No Keywords", localization: SingleLocalization.self)
  }

  func testNoTitle() {
    expectErrorGenerating(forMock: "No Title", localization: SingleLocalization.self)
  }

  func testPoorHTML() throws {
    try generate(
      forMock: "Poor HTML",
      localization: SingleLocalization.self,
      expectValidationFailure: true
    )
  }

  func testRepositoryStructure() {
    _ = RepositoryStructure()
  }

  func testRightToLeft() throws {
    try generate(forMock: "Right‐to‐Left", localization: RightToLeftLocalization.self)
  }

  struct StandInError: PresentableError {
    func presentableDescription() -> StrictString {
      return "[...]"
    }
  }
  func testSiteGenerationError() {
    #if !PLATFORM_SUFFERS_SEGMENTATION_FAULTS
      let errors: [SiteGenerationError] = [
        .foundationError(StandInError()),
        .invalidDomain("[...]"),
        .missingTitle(page: "[...]"),
        .syntaxError(
          page: "[...]",
          error: SyntaxError(
            file: "[...]",
            index: "".scalars.startIndex,
            description: UserFacing<StrictString, InterfaceLocalization>({ _ in "[...]" }),
            context: "[...]"
          )
        ),
      ]
      for index in errors.indices {
        let error = errors[index]
        testCustomStringConvertibleConformance(
          of: error,
          localizations: InterfaceLocalization.self,
          uniqueTestName: index.inDigits(),
          overwriteSpecificationInsteadOfFailing: false
        )
      }
    #endif
  }

  func testSiteValidationError() throws {
    #if !PLATFORM_SUFFERS_SEGMENTATION_FAULTS
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
        .syntaxError(parseFailure),
      ]
      for index in errors.indices {
        let error = errors[index]
        testCustomStringConvertibleConformance(
          of: error,
          localizations: InterfaceLocalization.self,
          uniqueTestName: index.inDigits(),
          overwriteSpecificationInsteadOfFailing: false
        )
      }

      #if !PLATFORM_LACKS_FOUNDATION_FILE_MANAGER
        try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { url in
          let invalidHTML = "p>This paragraph is broken.</p>"
          try invalidHTML.save(to: url.appendingPathComponent("Invalid.html"))
          let warnings = Site<InterfaceLocalization, Unfolder>.validate(site: url)
          XCTAssert(¬warnings.isEmpty)
        }
      #endif
    #endif
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
