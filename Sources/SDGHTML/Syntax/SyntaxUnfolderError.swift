/*
 SyntaxUnfolderError.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020–2023 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText
import SDGLocalization

import SDGWebLocalizations

extension SyntaxUnfolder {

  internal enum Error: PresentableError {

    // MARK: - Cases

    case missingAttribute(
      element: ElementSyntax,
      attribute: UserFacing<StrictString, InterfaceLocalization>
    )

    // MARK: - PresentableError

    internal func presentableDescription() -> StrictString {
      switch self {
      case .missingAttribute(let element, let attribute):
        return UserFacing<StrictString, InterfaceLocalization>({ localization in
          switch localization {
          case .englishUnitedKingdom:
            return
              "A required attribute is missing. The ‘\(element.nameText)’ element requires the ‘\(attribute.resolved(for: localization))’ attribute."
          case .englishUnitedStates, .englishCanada:
            return
              "A required attribute is missing. The “\(element.nameText)” element requires the “\(attribute.resolved(for: localization))” attribute."
          case .deutschDeutschland:
            return
              "Eine nötige Eigenschaft fehlt. Das „\(element.nameText)“‐Element benötigt die „\(attribute.resolved(for: localization))“ Eigenschaft."
          }
        }).resolved()
      }
    }
  }
}
