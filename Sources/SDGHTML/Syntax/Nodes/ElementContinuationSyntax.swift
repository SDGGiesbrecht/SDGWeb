/*
 ElementContinuationSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// The content and closing tag of an element.
public struct ElementContinuationSyntax: ContainerSyntax, Syntax {

  // MARK: - Parsing

  #if !os(Windows)
    // #workaround(Swift 5.3.1, Automatic indices here and in the other nodes has been disconnected to dodge a COMDAT issue on Windows.)
    private enum Child: ChildSet {
      case content
      case closingTag
    }
    private static let indices = Child.indexTable()
  #endif

  // MARK: - Initialization

  /// Creates an element continuation node.
  ///
  /// - Parameters:
  ///     - content: The content.
  ///     - closingTag: The closing tag.
  public init(content: ListSyntax<ContentSyntax>, closingTag: ClosingTagSyntax) {
    _storage = _SyntaxStorage(children: [content, closingTag])
  }

  /// Creates an element continuation node.
  ///
  /// - Parameters:
  ///   - elementName: The tag name.
  ///   - contents: Optional. The contents of the element.
  public init(elementName: String, contents: ListSyntax<ContentSyntax> = []) {
    self.init(content: contents, closingTag: ClosingTagSyntax(name: elementName))
  }

  // MARK: - Children

  /// The content of the element.
  public var content: ListSyntax<ContentSyntax> {
    get {
      return _storage.children[0]
        as! ListSyntax<ContentSyntax>
    }
    set {
      _storage.children[0] = newValue
    }
  }

  /// The closing tag.
  public var closingTag: ClosingTagSyntax {
    get {
      return _storage.children[1] as! ClosingTagSyntax
    }
    set {
      _storage.children[1] = newValue
    }
  }

  // MARK: - Syntax

  public var _storage: _SyntaxStorage

  public mutating func format(indentationLevel: Int) {
    content.formatContentList(indentationLevel: indentationLevel + 1, forDocument: false)
    closingTag.format(indentationLevel: indentationLevel)
  }

  public mutating func performSingleUnfoldingPass<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    try unfoldChildren(with: unfolder)
    try unfoldContainer(with: unfolder)
  }
}
