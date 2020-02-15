/*
 WindowsMain.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

@testable import SDGHTMLTests
@testable import SDGWebTests

extension APITests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testAttribute", testAttribute),
      ("testAttributed", testAttributed),
      ("testAttributes", testAttributes),
      ("testAttributeValue", testAttributeValue),
      ("testComment", testComment),
      ("testClosingTag", testClosingTag),
      ("testContainerSyntax", testContainerSyntax),
      ("testDocument", testDocument),
      ("testElement", testElement),
      ("testElementContinuation", testElementContinuation),
      ("testElementFactories", testElementFactories),
      ("testExampleURL", testExampleURL),
      ("testEscaping", testEscaping),
      ("testFormatting", testFormatting),
      ("testListSyntax", testListSyntax),
      ("testOpeningTag", testOpeningTag),
      ("testParsing", testParsing),
      ("testPercentEncoding", testPercentEncoding),
      ("testRedirect", testRedirect),
      ("testSyntaxError", testSyntaxError),
      ("testSyntaxUnfolder", testSyntaxUnfolder),
      ("testTextDirection", testTextDirection),
      ("testText", testText),
      ("testValidLink", testValidLink),
    ])
  ]
}

extension InternalTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testSyntaxUnfolderError", testSyntaxUnfolderError),
    ])
  ]
}

extension RegressionTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testDataAttributesAllowed", testDataAttributesAllowed),
      ("testValidationOfMultiScalarClusters", testValidationOfMultiScalarClusters),
    ])
  ]
}

extension APITests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testCopyright", testCopyright),
      ("testInvalidHTML", testInvalidHTML),
      ("testLocalized", testLocalized),
      ("testNoColon", testNoColon),
      ("testNoCSS", testNoCSS),
      ("testNoMetadata", testNoMetadata),
      ("testNoKeywords", testNoKeywords),
      ("testNoTitle", testNoTitle),
      ("testPoorHTML", testPoorHTML),
      ("testRepositoryStructure", testRepositoryStructure),
      ("testRightToLeft", testRightToLeft),
      ("testSiteGenerationError", testSiteGenerationError),
      ("testSiteValidationError", testSiteValidationError),
      ("testUnknownLocalization", testUnknownLocalization),
      ("testUnlocalized", testUnlocalized),
    ])
  ]
}

extension RegressionTests {
  static let windowsTests: [XCTestCaseEntry] = [
    testCase([
      ("testRedirect", testRedirect),
    ])
  ]
}

var tests = [XCTestCaseEntry]()
tests += APITests.windowsTests
tests += InternalTests.windowsTests
tests += RegressionTests.windowsTests
tests += APITests.windowsTests
tests += RegressionTests.windowsTests

XCTMain(tests)
