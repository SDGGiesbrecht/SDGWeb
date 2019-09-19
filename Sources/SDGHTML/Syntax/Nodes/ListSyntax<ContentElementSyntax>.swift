/*
 ListSyntax<ContentElementSyntax>.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic

extension ListSyntax where Entry == ContentElementSyntax {

    // MARK: - Parsing

    internal static func parse(source: String) -> Result<ListSyntax<ContentElementSyntax>, SyntaxError> {
        var source = source
        return parse(fromEndOf: &source, untilOpeningOf: nil).map { $0.content }
    }

    internal static func parse(
        fromEndOf source: inout String,
        untilOpeningOf element: String?) -> Result<(tag: OpeningTagSyntax?, content: ListSyntax<ContentElementSyntax>), SyntaxError> {
        var tag: OpeningTagSyntax?
        var entries: [ContentElementSyntax] = []
        parsing: while ¬source.isEmpty {
            if source.scalars.last == ">" {
                if source.scalars.hasSuffix("\u{2D}\u{2D}>".scalars) {
                    switch CommentSyntax.parse(fromEndOf: &source) {
                    case .failure(let error):
                        return .failure(error)
                    case .success(let parsedComment):
                        entries.append(ContentElementSyntax(kind: .comment(parsedComment)))
                    }
                } else {
                    switch ElementSyntax.parse(fromEndOf: &source) {
                    case .failure(let error):
                        return .failure(error)
                    case .success(let parsedElement):
                        if parsedElement.continuation == nil,
                            parsedElement.openingTag.name.source() == element {
                            tag = parsedElement.openingTag
                            break parsing
                        } else {
                            entries.append(ContentElementSyntax(kind: .element(parsedElement)))
                        }
                    }
                }
            } else {
                entries.append(ContentElementSyntax(kind: .text(TextSyntax.parse(fromEndOf: &source))))
            }
        }
        let list = ListSyntax<ContentElementSyntax>(entries: entries.reversed())
        return .success((tag, list))
    }
}
