/*
 DocumentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

/// A syntax node representing an HTML document.
public struct DocumentSyntax : Syntax {

    // MARK: - Parsing

    private enum Child : CaseIterable {
        case content
    }
    private static let indices = Child.allCases.bijectiveIndexMapping

    /// Parses the source into a syntax tree.
    ///
    /// - Parameters:
    ///     - source: The source of the HTML document.
    public static func parse(source: String) -> Result<DocumentSyntax, SyntaxError> {
        return ContentSyntax.parse(source: source).map { content in
            return DocumentSyntax(content: content)
        }
    }

    // MARK: - Initialization

    /// Creates a document.
    ///
    /// - Parameters:
    ///     - content: The content.
    public init(content: ContentSyntax) {
        _storage = SyntaxStorage(children: [content])
    }

    // MARK: - Children

    /// The content.
    public var content: ContentSyntax {
        return _storage.children[DocumentSyntax.indices[.content]!] as! ContentSyntax
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
        for node in descendents() {
            defer {
                if node is TokenSyntax {
                    location = file.index(location, offsetBy: node.source().scalars.count)
                }
            }

            if let attribute = node as? AttributeSyntax {
                result.append(contentsOf: attribute.validate(location: location, file: file, baseURL: baseURL))
            } else if let element = node as? OpeningTagSyntax {
                result.append(contentsOf: element.validate(location: location, file: file, baseURL: baseURL))
            }
        }
        return result
    }

    // MARK: - Syntax

    public var _storage: _SyntaxStorage
}
