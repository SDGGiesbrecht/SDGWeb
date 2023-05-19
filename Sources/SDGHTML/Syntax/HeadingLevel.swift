/*
 HeadingLevel.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020–2023 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// The level of a section heading.
public enum HeadingLevel: CaseIterable, Sendable {

  // MARK: - Cases

  /// Heading level 1 (`<h2>`).
  case level1
  /// Heading level 2 (`<h3>`).
  case level2
  /// Heading level 3 (`<h4>`).
  case level3
  /// Heading level 4 (`<h5>`).
  case level4
  /// Heading level 6 (`<h6>`).
  case level5

  internal var htmlTag: String {
    let number: Int = HeadingLevel.allCases.firstIndex(of: self)! + 2
    return "h\(number)"
  }
}
