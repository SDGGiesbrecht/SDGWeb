/*
 InternalTests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

@testable import SDGHTML

import SDGWebLocalizations

import XCTest

import SDGLocalizationTestUtilities
import SDGXCTestUtilities

class InternalTests: TestCase {

  func testChildSet() {
    enum Children: ChildSet {
      case a, b
    }
    _ = Children.indexTable()
  }

  func testSyntaxUnfolderError() {
    testCustomStringConvertibleConformance(
      of: SyntaxUnfolder.Error.missingAttribute(
        element: ElementSyntax(name: "element", empty: true),
        attribute: UserFacing<StrictString, InterfaceLocalization>({ _ in "attribute" })
      ),
      localizations: InterfaceLocalization.self,
      uniqueTestName: "Missing Attribute",
      overwriteSpecificationInsteadOfFailing: false
    )
  }
}
