/*
 RightToLeftLocalization.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

enum RightToLeftLocalization: String, InputLocalization {
  case עברית = "he"
  static var fallbackLocalization = RightToLeftLocalization.עברית
}
