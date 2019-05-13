/*
 AttributeValueSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

public struct AttributeValueSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case equals
        case openingQuotationMark
        case value
        case closingQuotationMark
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> AttributeValueSyntax? {
        if source.scalars.last ≠ "\u{22}" {
            return nil
        }
        let end = source.scalars.index(before: source.scalars.endIndex)
        var start = end
        while start ≠ source.scalars.startIndex,
            source.scalars[start] ≠ "\u{ff}" {
                start = source.scalars.index(before: start)
        }
        let text = String(source[start...])
        source.scalars.removeSubrange(start...)
        let value = AttributeValueSyntax(_storage: <#T##_SyntaxStorage#>)
        return TextSyntax(_storage: SyntaxStorage(children: [TokenSyntax(kind: .text(text))]))
    }

    // MARK: - Children

    public var equals: TokenSyntax {
        return children[AttributeValueSyntax.indices[.equals]!] as! TokenSyntax
    }

    public var openingQuotationMark: TokenSyntax {
        return children[AttributeValueSyntax.indices[.openingQuotationMark]!] as! TokenSyntax
    }

    public var value: TokenSyntax {
        return children[AttributeValueSyntax.indices[.value]!] as! TokenSyntax
    }

    public var closingQuotationMark: TokenSyntax {
        return children[AttributeValueSyntax.indices[.closingQuotationMark]!] as! TokenSyntax
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
