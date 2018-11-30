/*
 CSS.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGText

internal enum CSS {

    internal static let root: StrictString = {
        var result = StrictString(Resources.root)
        result.replaceMatches(for: CompositePattern([
            LiteralPattern("/*".scalars),
            RepetitionPattern(ConditionalPattern({ _ in true }), consumption: .lazy),
            LiteralPattern("*/\n\n".scalars)
            ]), with: "".scalars)
        return result
    }()
}
