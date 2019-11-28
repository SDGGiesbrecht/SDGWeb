/*
 CSS.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import SDGText

/// A namespace for functions related to CSS.
public enum CSS {

  /// A recommended root CSS file.
  public static let root: StrictString = {
    var result = StrictString(Resources.root)
    result.replaceMatches(
      for: "/*".scalars
        + RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy)
        + "*/\n\n".scalars,
      with: "".scalars
    )
    return result
  }()
}
