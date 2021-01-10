/*
 AttributeValueSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An attribute value.
public struct AttributeValueSyntax: Syntax {

  // MARK: - Parsing

  #if !os(Windows)
    // #workaround(Swift 5.3.2, Automatic indices here and in the other nodes has been disconnected to dodge a COMDAT issue on Windows.)
    private enum Child: ChildSet {
      case equals
      case openingQuotationMark
      case value
      case closingQuotationMark
    }
    private static let indices = Child.indexTable()
  #endif

  internal static func parse(
    fromEndOf source: inout String
  ) -> Result<AttributeValueSyntax?, SyntaxError> {
    if source.scalars.last ≠ "\u{22}" {
      return .success(nil)
    }
    source.scalars.removeLast()
    let value = TokenSyntax.parseAttribute(fromEndOf: &source)
    if source.scalars.last ≠ "\u{22}" {
      let attributeSource = source + value.source() + "\u{22}"
      return .failure(
        SyntaxError(
          file: attributeSource,
          index: attributeSource.scalars.index(before: attributeSource.scalars.endIndex),
          description: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "A quotation mark is not paired."
            case .deutschDeutschland:
              return "Ein Anführungszeichen steht allein."
            }
          }),
          context: attributeSource
        )
      )
    }
    source.scalars.removeLast()
    if source.scalars.last ≠ "=" {
      return .failure(
        SyntaxError(
          file: source,
          index: source.scalars.endIndex,
          description: UserFacing<StrictString, InterfaceLocalization>({ localization in
            switch localization {
            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
              return "An equals sign is missing."
            case .deutschDeutschland:
              return "Ein Gleichheitszeichen fehlt."
            }
          }),
          context: "\u{22}" + value.source() + "\u{22}"
        )
      )
    }
    source.scalars.removeLast()
    return .success(
      AttributeValueSyntax(
        equals: TokenSyntax(kind: .equalsSign),
        openingQuotationMark: TokenSyntax(kind: .quotationMark),
        value: value,
        closingQuotationMark: TokenSyntax(kind: .quotationMark)
      )
    )
  }

  // MARK: - Initialization

  /// Creates an attribute value.
  ///
  /// - Parameters:
  ///     - equals: The equals sign. (Supplied automatically if omitted.)
  ///     - openingQuotationMark: The opening quotation mark. (Supplied automatically if omitted.)
  ///     - value: The value.
  ///     - closingQuotationMark: The closing quotation mark. (Supplied automatically if omitted.)
  public init(
    equals: TokenSyntax = TokenSyntax(kind: .equalsSign),
    openingQuotationMark: TokenSyntax = TokenSyntax(kind: .quotationMark),
    value: TokenSyntax,
    closingQuotationMark: TokenSyntax = TokenSyntax(kind: .quotationMark)
  ) {
    _storage = SyntaxStorage(children: [equals, openingQuotationMark, value, closingQuotationMark])
  }

  /// Creates an attribute value.
  ///
  /// - Parameters:
  ///     - value: Optional. The attribute value.
  public init(value: TokenKind? = nil) {
    self.init(value: value.map({ TokenSyntax(kind: $0) }) ?? TokenSyntax(kind: .attributeText("")))
  }

  /// Creates an attribute value.
  ///
  /// - Parameters:
  ///     - valueText: Optional. The attribute value.
  public init(valueText: String? = nil) {
    self.init(value: TokenKind.attributeText(HTML.escapeTextForAttribute(valueText ?? "")))
  }

  // MARK: - Children

  /// The equals sign.
  public var equals: TokenSyntax {
    get {
      return _storage.children[0] as! TokenSyntax
    }
    set {
      _storage.children[0] = newValue
    }
  }

  /// The opening quotation mark.
  public var openingQuotationMark: TokenSyntax {
    get {
      return _storage.children[1] as! TokenSyntax
    }
    set {
      _storage.children[1] = newValue
    }
  }

  /// The value.
  public var value: TokenSyntax {
    get {
      return _storage.children[2] as! TokenSyntax
    }
    set {
      _storage.children[2] = newValue
    }
  }

  /// The closing quotation mark.
  public var closingQuotationMark: TokenSyntax {
    get {
      return _storage.children[3] as! TokenSyntax
    }
    set {
      _storage.children[3] = newValue
    }
  }

  // MARK: - Computed Properties

  /// The value.
  public var valueText: String {
    get {
      return HTML.unescapeTextForAttribute(value.tokenKind.text)
    }
    set {
      value = TokenSyntax(kind: .attributeText(HTML.escapeTextForAttribute(newValue)))
    }
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage
}
