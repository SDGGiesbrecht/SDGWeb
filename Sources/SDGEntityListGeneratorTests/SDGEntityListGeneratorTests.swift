/*
 SDGEntityListGeneratorTests.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2022 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import XCTest

final class SDGEntityListGeneratorTests: XCTestCase {

  // Fix the spelling of “test” and then run the test to execute the generator.
  func tesEntityListGenerator() throws {
    try EntityListGenerator.main()
  }
}