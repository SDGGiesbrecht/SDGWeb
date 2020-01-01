/*
 ListSyntax<ContentSyntax>.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGMathematics

extension ListSyntax where Entry == ContentSyntax {

  // MARK: - Parsing

  internal static func parse(source: String) -> Result<ListSyntax<ContentSyntax>, SyntaxError> {
    var source = source
    return parse(fromEndOf: &source, untilOpeningOf: nil).map { $0.content }
  }

  internal static func parse(
    fromEndOf source: inout String,
    untilOpeningOf element: String?
  ) -> Result<(tag: OpeningTagSyntax?, content: ListSyntax<ContentSyntax>), SyntaxError> {
    var tag: OpeningTagSyntax?
    var entries: [ContentSyntax] = []
    parsing: while ¬source.isEmpty {
      if source.scalars.last == ">" {
        if source.scalars.hasSuffix("\u{2D}\u{2D}>".scalars) {
          switch CommentSyntax.parse(fromEndOf: &source) {
          case .failure(let error):
            return .failure(error)
          case .success(let parsedComment):
            entries.append(ContentSyntax(kind: .comment(parsedComment)))
          }
        } else {
          switch ElementSyntax.parse(fromEndOf: &source) {
          case .failure(let error):
            return .failure(error)
          case .success(let parsedElement):
            if parsedElement.continuation == nil,
              parsedElement.openingTag.name.source() == element
            {
              tag = parsedElement.openingTag
              break parsing
            } else {
              entries.append(ContentSyntax(kind: .element(parsedElement)))
            }
          }
        }
      } else {
        entries.append(ContentSyntax(kind: .text(TextSyntax.parse(fromEndOf: &source))))
      }
    }
    let list = ListSyntax<ContentSyntax>(entries: entries.reversed())
    return .success((tag, list))
  }

  // MARK: - Formatting

  internal mutating func formatContentList(indentationLevel: Int, forDocument: Bool) {
    if count ≤ 1,
      allSatisfy({ node in
        if case .text = node.kind {
          return true
        } else {
          return false
        }
      })
    {
      // Inline style.
      if case .text(var text) = first?.kind {
        text.trimWhitespace()
        text.format(indentationLevel: indentationLevel)
        self = [ContentSyntax(kind: .text(text))]
      }
    } else {
      // Block style.
      let leadingWhitespace = "\n" + String(repeating: " ", count: indentationLevel)
      let trailingWhitespace = "\n"
        + String(repeating: " ", count: Swift.max(0, indentationLevel − 1))

      // Add medial whitespace if missing.
      var hasPrecedingTextNode = false
      var index: Int = startIndex
      while index ≠ endIndex {
        defer { index = self.index(after: index) }
        if forDocument ∧ index == startIndex {
          continue
        }
        let entry = self[index]
        if case .text = entry.kind {
          hasPrecedingTextNode = true
        } else {
          if hasPrecedingTextNode {
            // ✓; turn it off for the next node.
            hasPrecedingTextNode = false
          } else {
            // ✗; insert a text node here.
            self.insert(ContentSyntax(kind: .text(TextSyntax())), at: index)
            hasPrecedingTextNode = true
          }
        }
      }
      if ¬forDocument ∧ ¬hasPrecedingTextNode {  // Trailing text node.
        self.append(ContentSyntax(kind: .text(TextSyntax())))
      }

      // Indent.
      for index in self.indices {
        self[index].format(indentationLevel: indentationLevel)
        self[index].whereMeaningfulSetLeadingWhitespace(to: leadingWhitespace)
        self[index].whereMeaningfulSetTrailingWhitespace(to: leadingWhitespace)
        if index == self.indices.last {
          self[index].whereMeaningfulSetTrailingWhitespace(to: trailingWhitespace)
        }
      }
    }
  }
}
