/*
 DocumentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

import SDGText
import SDGPersistence
import SDGLocalization

import SDGWebLocalizations

/// A syntax node representing an HTML document.
public struct DocumentSyntax: ContainerSyntax, Equatable, FileConvertible, Syntax {

  // MARK: - Parsing

  private enum Child: ChildSet {
    case content
  }
  private static let indices = Child.indexTable()

  /// Parses the source into a syntax tree.
  ///
  /// - Parameters:
  ///     - source: The source of the HTML document.
  public static func parse(source: String) -> Result<DocumentSyntax, SyntaxError> {
    return ListSyntax<ContentSyntax>.parse(source: source).map { content in
      return DocumentSyntax(content: content)
    }
  }

  // MARK: - Initialization

  /// Creates a document.
  ///
  /// - Parameters:
  ///     - content: The content.
  public init(content: ListSyntax<ContentSyntax>) {
    _storage = SyntaxStorage(children: [content])
  }

  // MARK: - Children

  /// The content.
  public var content: ListSyntax<ContentSyntax> {
    get {
      return _storage.children[DocumentSyntax.indices[.content]!] as! ListSyntax<ContentSyntax>
    }
    set {
      _storage.children[DocumentSyntax.indices[.content]!] = newValue
    }
  }

  // MARK: - Validation

  /// Validates the document.
  ///
  /// - Parameters:
  ///     - baseURL: The base URL to use for any relative links in the document.
  public func validate(baseURL: URL) -> [SyntaxError] {
    let file = source()
    var location = file.scalars.startIndex
    var result: [SyntaxError] = []

    let headerNames: [String: Int] = Dictionary(
      uniqueKeysWithValues: (1...6).map({ ("h\($0)", $0) })
    )
    var maxHeaderLevel = 0

    for node in descendents() {
      defer {
        if node is TokenSyntax {
          location = file.scalars.index(location, offsetBy: node.source().scalars.count)
        }
      }

      if let attribute = node as? AttributeSyntax {
        result.append(
          contentsOf: attribute.validate(location: location, file: file, baseURL: baseURL)
        )
      } else if let element = node as? OpeningTagSyntax {
        result.append(
          contentsOf: element.validate(location: location, file: file, baseURL: baseURL)
        )
      } else if let element = node as? ElementSyntax {
        let elementName = element.nameText
        if let level = headerNames[elementName],
          level > maxHeaderLevel
        {
          defer { maxHeaderLevel = level }
          let expectedLevel = maxHeaderLevel + 1
          if level > expectedLevel {
            result.append(
              SyntaxError.init(
                file: file,
                index: location,
                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                  switch localization {
                  case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                    return
                      "A level \(level.inDigits()) heading appears before any level \(expectedLevel.inDigits()) heading."
                  case .deutschDeutschland:
                    return
                      "Eine Überschrift der \(level.inDigits()). Ebene kommt vor irgendeine Überschrift der \(expectedLevel.inDigits()). Ebene."
                  }
                }),
                context: element.source()
              )
            )
          }
        }
      }
    }
    return result
  }

  // MARK: - Equatable

  public static func == (precedingValue: DocumentSyntax, followingValue: DocumentSyntax) -> Bool {
    return precedingValue.source() == followingValue.source()
  }

  // MARK: - FileConvertible

  public init(file: Data, origin: URL?) throws {
    let source = try String(file: file, origin: origin)
    switch DocumentSyntax.parse(source: source) {
    case .success(let document):
      self = document
    case .failure(let error):
      throw error
    }
  }

  public var file: Data {
    return source().file
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage

  public mutating func format(indentationLevel: Int) {
    content.formatContentList(indentationLevel: indentationLevel, forDocument: true)
  }

  public mutating func performSingleUnfoldingPass<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    try unfoldChildren(with: unfolder)
    try unfoldContainer(with: unfolder)
    try unfolder.unfold(document: &self)
  }
}
