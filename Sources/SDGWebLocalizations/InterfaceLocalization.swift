/*
 InterfaceLocalization.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2023 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLocalization

public enum InterfaceLocalization: String, InputLocalization {

  case englishUnitedKingdom = "en\u{2D}GB"
  case englishUnitedStates = "en\u{2D}US"
  case englishCanada = "en\u{2D}CA"

  case deutschDeutschland = "de\u{2D}DE"

  public static var fallbackLocalization: InterfaceLocalization = .englishUnitedKingdom
}
