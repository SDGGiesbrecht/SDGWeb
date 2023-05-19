/*
 RegressionTests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2023 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGHTML

import XCTest

import SDGXCTestUtilities

class RegressionTests: TestCase {

  func testDataAttributesAllowed() throws {
    let thisFile = URL(fileURLWithPath: #filePath)
    let document = try DocumentSyntax.parse(source: "<div data\u{2D}custom></div>").get()
    let report = document.validate(baseURL: thisFile)
    XCTAssert(report.isEmpty, "\(report)")
  }

  func testValidationOfMultiScalarClusters() throws {
    // Untracked

    _ = try DocumentSyntax.parse(source: "🇮🇱").get().validate(baseURL: URL(fileURLWithPath: "/"))
  }
}
