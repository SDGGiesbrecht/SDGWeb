/*
 AnyLocalization.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

// #workaround(SDGCornerstone 4.1.0, Move to SDGCornerstone?)
internal struct AnyLocalization: Localization {

  // MARK: - Initialization

  internal init<L>(_ localization: L) where L: Localization {
    self.code = localization.code
  }

  internal init(code: String) {  // @exempt(from: tests)
    self.code = code
  }

  // MARK: - Localization

  internal init?(exactly code: String) {  // @exempt(from: tests)
    self.code = code
  }

  internal let code: String

  internal static var fallbackLocalization: AnyLocalization = { unreachable() }()
}
