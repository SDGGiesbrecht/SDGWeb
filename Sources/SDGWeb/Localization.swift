/*
 Localization.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGCollections
import SDGText
import SDGLocalization

internal func localize<L>(_ string: inout StrictString, for localization: L) where L : InputLocalization {
    let opaqueLocalizationIndex = L.allCases.firstIndex(where: { $0.code == localization.code })!
    let localizationIndex = L.allCases.distance(from: L.allCases.startIndex, to: opaqueLocalizationIndex)

    string.scalars.mutateMatches(for: CompositePattern([
        LiteralPattern("[*".scalars),
        RepetitionPattern(NotPattern(LiteralPattern("*]".scalars))),
        LiteralPattern("*]".scalars)
        ])) { match -> StrictString in
            let components = match.contents.dropFirst(2).dropLast(2).components(separatedBy: "*/*".scalars)
            if components.count > 1 {
                var localized = StrictString(components[localizationIndex].contents)
                if localized.lines.count > 1 {
                    if localized.lines.first?.line.allSatisfy({ $0 == " " }) == true {
                        localized.lines.removeFirst()
                    }
                    if localized.lines.last?.line.allSatisfy({ $0 == " " }) == true {
                        localized.lines.removeLast()
                    }
                } else {
                    while localized.first == " " {
                        localized.removeFirst()
                    }
                    while localized.last == " " {
                        localized.removeLast()
                    }
                }
                return localized
            } else {
                return StrictString(match.contents)
            }
    }
}
