/*
 ContentSyntax+Factories.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

extension ContentSyntax {

  /// Creates text.
  public static func text(_ text: String) -> ContentSyntax {
    return ContentSyntax(kind: .text(TextSyntax(text: text)))
  }
}
