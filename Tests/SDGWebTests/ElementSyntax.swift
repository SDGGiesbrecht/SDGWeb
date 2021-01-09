/*
 ElementSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGHTML

extension ElementSyntax {

  static func page(attributes: [String: String], contents: ListSyntax<ContentSyntax>)
    -> ElementSyntax
  {
    return ElementSyntax(name: "page", attributes: attributes, contents: contents)
  }

  static func localized(_ contents: ListSyntax<ContentSyntax>) -> ElementSyntax {
    return ElementSyntax(name: "localized", attributes: [:], contents: contents)
  }
  static func english(_ contents: ListSyntax<ContentSyntax>) -> ElementSyntax {
    return ElementSyntax(name: "en", attributes: [:], contents: contents)
  }
  static func deutsch(_ inhalt: ListSyntax<ContentSyntax>) -> ElementSyntax {
    return ElementSyntax(name: "de", attributes: [:], contents: inhalt)
  }
  static func עברית(_ תוכן: ListSyntax<ContentSyntax>) -> ElementSyntax {
    return ElementSyntax(name: "he", attributes: [:], contents: תוכן)
  }
  static func unknownLanguage(_ contents: ListSyntax<ContentSyntax>) -> ElementSyntax {
    return ElementSyntax(name: "zxx", attributes: [:], contents: contents)
  }
}
