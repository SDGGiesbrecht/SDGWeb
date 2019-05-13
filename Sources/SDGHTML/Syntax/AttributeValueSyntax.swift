/*
 AttributeValueSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

public struct AttributeValueSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case equals
        case openingQuotationMark
        case value
        case closingQuotationMark
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    internal static func parse(fromEndOf source: inout String) -> Result<AttributeValueSyntax?, SyntaxError> {
        if source.scalars.last ≠ "\u{22}" {
            return .success(nil)
        }
        source.scalars.removeLast()
        let value = TokenSyntax.parseAttribute(fromEndOf: &source)
        if source.scalars.last ≠ "\u{22}" {
            #warning("Throw. Extraneus quotation mark.")
            return .failure(SyntaxError())
        }
        source.scalars.removeLast()
        if source.scalars.last ≠ "=" {
            #warning("Throw. Missing equals sign.")
            return .failure(SyntaxError())
        }
        source.scalars.removeLast()
        return .success(AttributeValueSyntax(_storage: SyntaxStorage(children: [
            TokenSyntax(kind: .equalsSign),
            TokenSyntax(kind: .quotationMark),
            value,
            TokenSyntax(kind: .quotationMark),
            ])))
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
