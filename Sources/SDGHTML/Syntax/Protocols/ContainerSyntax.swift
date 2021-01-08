/*
 ContainerSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2021 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A node which has associated content, either directly or through one of its children.
public protocol ContainerSyntax: Syntax {

  /// The content of the element.
  var content: ListSyntax<ContentSyntax> { get set }
}

extension ContainerSyntax {

  internal mutating func unfoldContainer<Unfolder>(with unfolder: Unfolder) throws
  where Unfolder: SyntaxUnfolderProtocol {
    try unfolder.unfold(contentList: &content)
  }

  /// Returns the list of all immediate child elements.
  public func childElements() -> AnyCollection<ElementSyntax> {
    return AnyCollection(
      content.lazy.compactMap { entry in
        if case .element(let element) = entry.kind {
          return element
        }
        return nil
      }
    )
  }
}
