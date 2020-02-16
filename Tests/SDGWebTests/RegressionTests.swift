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
import SDGWeb

import SDGWebLocalizations

import XCTest

import SDGXCTestUtilities

class SDGWebRegressionTests: TestCase {

  func testRedirect() throws {
    // Untracked.

    try FileManager.default.withTemporaryDirectory(appropriateFor: nil) { url in
      let redirectFile = DocumentSyntax.redirect(
        language: InterfaceLocalization.deutschDeutschland,
        target: URL(fileURLWithPath: "../")
      ).source()
      try redirectFile.save(to: url.appendingPathComponent("Redirect.html"))
      let warnings = Site<InterfaceLocalization, SyntaxUnfolder>.validate(site: url)
      XCTAssert(warnings.isEmpty, "\(warnings)")
    }
  }
}
