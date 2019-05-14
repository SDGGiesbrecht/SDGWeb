/*
 AttributeSyntax.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGLogic
import SDGCollections
import SDGLocalization

import SDGWebLocalizations
import SDGHTML

extension AttributeSyntax {

    internal func validate(
        location: String.ScalarView.Index,
        file: String,
        baseURL: URL) -> [SiteValidationError] {
        var results: [SiteValidationError] = []
        validateValuePresence(location: location, file: file, results: &results)
        validateURLValue(
            location: location,
            file: file,
            baseURL: baseURL,
            results: &results)
        return results
    }

    private static let nonEmptyAttributes: Set<String> = []
    private static let emptyAttributes: Set<String> = []
    private func validateValuePresence(
        location: String.ScalarView.Index,
        file: String,
        results: inout [SiteValidationError]) {
        let name = self.name.source()
        if name ∈ AttributeSyntax.nonEmptyAttributes {
            if value == nil {
                results.append(SiteValidationError.syntaxError(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute value is missing."
                        }

                    }),
                    context: source())))
            }
        } else if name ∈ AttributeSyntax.emptyAttributes {
            if value ≠ nil {
                results.append(SiteValidationError.syntaxError(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "An attribute has an invalid value."
                        }

                    }),
                    context: source())))
            }
        } else {
            results.append(SiteValidationError.syntaxError(SyntaxError(
                file: file,
                index: location,
                description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                    switch localization {
                    case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                        return "Unknown attribute."
                    }

                }),
                context: source())))
        }
    }

    private static let urlAttributes: Set<String> = ["href", "src"]
    private func validateURLValue(
        location: String.ScalarView.Index,
        file: String,
        baseURL: URL,
        results: inout [SiteValidationError]) {
        if name.source() ∈ AttributeSyntax.urlAttributes,
            let urlString = value?.value.source() {
            if let url = URL(string: urlString, relativeTo: baseURL) {
                var dead = true
                if url.isFileURL {
                    if (try? url.checkResourceIsReachable()) == true {
                        dead = false
                    }
                } else {
                    let request = URLRequest(
                        url: url,
                        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                        timeoutInterval: 10)
                    let semaphore = DispatchSemaphore(value: 0)
                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if error ≠ nil,
                            let status = (response as? HTTPURLResponse)?.statusCode,
                            status.dividedAccordingToEuclid(by: 100) ≠ 2 {
                            dead = false
                        }
                        semaphore.signal()
                    }
                    task.resume()
                    semaphore.wait()
                }
                if dead {
                    results.append(SiteValidationError.syntaxError(SyntaxError(
                        file: file,
                        index: location,
                        description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                            switch localization {
                            case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                                return "A link is dead: \(urlString)"
                            }
                        }),
                        context: source())))
                }
            } else {
                results.append(SiteValidationError.syntaxError(SyntaxError(
                    file: file,
                    index: location,
                    description: UserFacing<StrictString, InterfaceLocalization>({ localization in
                        switch localization {
                        case .englishUnitedKingdom, .englishUnitedStates, .englishCanada:
                            return "A URL is invalid: \(urlString)"
                        }
                    }),
                    context: source())))
            }
        }
    }
}
