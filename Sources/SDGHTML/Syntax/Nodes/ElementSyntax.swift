/*
 ElementSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGText
import SDGLocalization

import SDGWebLocalizations

/// An HTML element.
public struct ElementSyntax: AttributedSyntax, ContainerSyntax, NamedSyntax, Syntax {

  // MARK: - Parsing

  private enum Child: CaseIterable {
    case openingTag
    case continuation
  }
  private static let indices = Dictionary(uniqueKeysWithValues: Child.allCases.enumerated().lazy.map({ ($1, $0) }))

  private static func unpairedGreaterThan() -> UserFacing<StrictString, InterfaceLocalization> {
    return UserFacing<StrictString, InterfaceLocalization>({ localization in
      switch localization {
      case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
        return "A greater‐than sign has no corresponding less‐than sign."
      case .deutschDeutschland:
        return "Ein Größer‐als‐Zeichen hat kein entsprechendes Kleiner‐als‐Zeichen."
      }
    })
  }

  internal static func parse(fromEndOf source: inout String) -> Result<ElementSyntax, SyntaxError> {
    let preservedSource = source
    source.scalars.removeLast()  // “>”
    switch AttributesSyntax.parse(fromEndOf: &source) {
    case .failure(let error):
      return .failure(error)
    case .success(let (name, attributes)):
      if source.scalars.isEmpty {
        return .failure(
          SyntaxError(
            file: preservedSource,
            index: preservedSource.scalars.endIndex,
            description: unpairedGreaterThan(),
            context: preservedSource
          )
        )
      }
      if source.scalars.last ≠ "/" {
        source.scalars.removeLast()  // “<”
        return .success(
          ElementSyntax(
            openingTag: OpeningTagSyntax(name: name, attributes: attributes)
          )
        )
      } else {
        source.scalars.removeLast()  // “/”
        if source.scalars.last ≠ "<" {
          return .failure(
            SyntaxError(
              file: preservedSource,
              index: preservedSource.scalars.endIndex,
              description: unpairedGreaterThan(),
              context: preservedSource
            )
          )
        } else {
          source.scalars.removeLast()  // “<”
          switch ListSyntax<ContentSyntax>.parse(
            fromEndOf: &source,
            untilOpeningOf: name.source()
          ) {
          case .failure(let error):
            return .failure(error)
          case .success(let (opening, content)):
            guard let tag = opening else {
              return .failure(
                SyntaxError(
                  file: preservedSource,
                  index: preservedSource.scalars.endIndex,
                  description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                      return "A closing tag has no corresponding opening tag."
                    case .deutschDeutschland:
                      return
                        "Eine schließende Markierung hat keine entsprechende öffnende Markierung."
                    }
                  }),
                  context: preservedSource
                )
              )
            }
            return .success(
              ElementSyntax(
                openingTag: tag,
                continuation: ElementContinuationSyntax(
                  content: content,
                  closingTag: ClosingTagSyntax(name: name)
                )
              )
            )
          }
        }
      }
    }
  }

  // MARK: - Initialization

  /// Creates an element.
  ///
  /// - Parameters:
  ///     - openingTag: The opening tag.
  ///     - continuation: Optional. Any continuation node.
  public init(openingTag: OpeningTagSyntax, continuation: ElementContinuationSyntax? = nil) {
    _storage = _SyntaxStorage(children: [openingTag, continuation])
  }

  /// Creates an element.
  ///
  /// - Parameters:
  ///     - name: The tag name.
  ///     - attributes: Optional. The attributes.
  ///     - empty: Whether the element should be created empty (without a continuation node).
  public init(name: String, attributes: [String: String] = [:], empty: Bool) {
    self.init(
      openingTag: OpeningTagSyntax(name: name, attributes: attributes),
      continuation: empty ? nil : ElementContinuationSyntax(elementName: name)
    )
  }

  /// Creates an element.
  ///
  /// - Parameters:
  ///     - name: The tag name.
  ///     - attributes: Optional. The attributes.
  ///     - contents: Optional. The contents of the element.
  public init(name: String, attributes: [String: String] = [:], contents: ListSyntax<ContentSyntax>)
  {
    self.init(
      openingTag: OpeningTagSyntax(name: name, attributes: attributes),
      continuation: ElementContinuationSyntax(elementName: name, contents: contents)
    )
  }

  // MARK: - Children

  /// The opening tag.
  public var openingTag: OpeningTagSyntax {
    get {
      return _storage.children[ElementSyntax.indices[.openingTag]!] as! OpeningTagSyntax
    }
    set {
      _storage.children[ElementSyntax.indices[.openingTag]!] = newValue
    }
  }

  /// The content and closing tag, if the element is not empty.
  public var continuation: ElementContinuationSyntax? {
    get {
      return _storage.children[ElementSyntax.indices[.continuation]!] as? ElementContinuationSyntax
    }
    set {
      _storage.children[ElementSyntax.indices[.continuation]!] = newValue
    }
  }

  // MARK: - Internal Utilities

  internal func requiredAttribute(
    named name: UserFacing<StrictString, InterfaceLocalization>
  ) throws -> String {
    if let value = attribute(named: name)?.valueText {
      return value
    }
    throw SyntaxUnfolder.Error.missingAttribute(element: self, attribute: name)
  }

  // MARK: - AttributedSyntax

  public var attributeDictionary: [String: String] {
    get {
      return openingTag.attributeDictionary
    }
    set {
      openingTag.attributeDictionary = newValue
    }
  }

  public func attribute(named name: String) -> AttributeSyntax? {
    return openingTag.attribute(named: name)
  }

  public mutating func apply(attribute: AttributeSyntax) {
    openingTag.apply(attribute: attribute)
  }

  public mutating func removeAttribute(named name: String) {
    openingTag.removeAttribute(named: name)
  }

  // MARK: - ContainerSyntax

  public var content: ListSyntax<ContentSyntax> {
    get {
      return continuation?.content ?? []
    }
    set {
      if ¬newValue.isEmpty,
        continuation == nil
      {
        continuation = ElementContinuationSyntax(
          content: newValue,
          closingTag: ClosingTagSyntax(name: openingTag.name)
        )
      } else {
        continuation?.content = newValue
      }
    }
  }

  // MARK: - NamedSyntax

  public static func nameTokenKind(_ text: String) -> TokenKind {
    return OpeningTagSyntax.nameTokenKind(text)
  }

  public var name: TokenSyntax {
    get {
      return openingTag.name
    }
    set {
      openingTag.name = newValue
      continuation?.closingTag.name = newValue
    }
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage

  public mutating func performSingleUnfoldingPass<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    try unfoldChildren(with: unfolder)
    try unfolder.unfold(element: &self)
  }
}
