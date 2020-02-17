/*
 RegressionTests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGHTML

import XCTest

import SDGXCTestUtilities

class SDGHTMLRegressionTests: TestCase {

  func testDataAttributesAllowed() throws {
    #if !os(Android)  // #workaround(Swift 5.1.3, Illegal instruction, entire module.)
      let thisFile = URL(fileURLWithPath: #file)
      let document = try DocumentSyntax.parse(source: "<div data\u{2D}custom></div>").get()
      let report = document.validate(baseURL: thisFile)
      XCTAssert(report.isEmpty, "\(report)")
    #endif
  }

  func testValidationOfMultiScalarClusters() throws {
    // Untracked

    #if !os(Android)  // #workaround(Swift 5.1.3, Illegal instruction, entire module.)
      _ = try DocumentSyntax.parse(source: "🇮🇱").get().validate(baseURL: URL(fileURLWithPath: "/"))
    #endif
  }
}
