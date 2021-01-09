/*
 TextDirection.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

extension TextDirection {

  // MARK: - Properties

  /// The HTML attribute value corresponding to this text direction.
  public var htmlAttribute: String {
    switch self {
    case .rightToLeftTopToBottom:
      return "rtl"
    case .leftToRightTopToBottom, .topToBottomRightToLeft:
      return "ltr"
    }
  }
}

extension Optional where Wrapped == TextDirection {

  /// The HTML attribute value corresponding to this text direction, or the `auto` HTML attribute value if the text direction is `nil`.
  public var htmlAttribute: String {
    switch self {
    case .some(let direction):
      return direction.htmlAttribute
    case .none:
      return "auto"
    }
  }

}
