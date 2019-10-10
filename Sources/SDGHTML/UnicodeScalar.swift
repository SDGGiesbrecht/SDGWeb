/*
 UnicodeScalar.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGLogic
import SDGCollections

extension Unicode.Scalar {

    public var isHTMLWhitespaceOrNewline: Bool {
        return value < 0x80 ∧ self ∈ CharacterSet.whitespacesAndNewlines
    }
}