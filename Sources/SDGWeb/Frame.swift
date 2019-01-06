/*
 Frame.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018–2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

internal enum Frame {

    internal static let frame: StrictString = {
        var result = StrictString(Resources.frame)
        result.replaceMatches(for: CompositePattern([
            LiteralPattern("\n<\u{21}\u{2D}\u{2D}".scalars),
            RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy),
            LiteralPattern("\u{2D}\u{2D}>\n\n".scalars)
            ]), with: "".scalars)
        result.replaceMatches(for: "[*UTF‐8*]", with: "utf\u{2D}8")
        return result
    }()
}
