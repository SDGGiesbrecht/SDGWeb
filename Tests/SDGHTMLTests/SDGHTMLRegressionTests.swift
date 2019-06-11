/*
 SDGHTMLRegressionTests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGHTML

import SDGXCTestUtilities

class SDGHTMLRegressionTests : TestCase {

    func testValidationOfMultiScalarClusters() throws {
        // Untracked

        _ = try DocumentSyntax.parse(source: "🇮🇱").get().validate(baseURL: URL(fileURLWithPath: "/"))
    }
}
