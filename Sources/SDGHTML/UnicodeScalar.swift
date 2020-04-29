/*
 UnicodeScalar.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

// #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
#if !os(WASI)
  import Foundation
#endif

import SDGLogic
import SDGCollections

extension Unicode.Scalar {

  // #workaround(Swift 5.2.2, Web doesn’t have Foundation yet.)
  #if !os(WASI)
    /// Whether or not the scalar represents whitespace or a newline in HTML.
    public var isHTMLWhitespaceOrNewline: Bool {
      return value < 0x80 ∧ self ∈ CharacterSet.whitespacesAndNewlines
    }
  #endif
}
