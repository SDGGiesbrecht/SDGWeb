/*
 DocumentSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGHTML

extension DocumentSyntax {

    internal func validate(baseURL: URL) -> [SiteValidationError] {
        let file = source()
        var location = file.scalars.startIndex
        var result: [SiteValidationError] = []
        for node in descendents() {
            defer {
                if node is TokenSyntax {
                    location = file.index(location, offsetBy: node.source().scalars.count)
                }
            }
            if let attribute = node as? AttributeSyntax {
                result.append(contentsOf: attribute.validate(location: location, file: file, baseURL: baseURL))
            }
        }
        return []
    }
}
