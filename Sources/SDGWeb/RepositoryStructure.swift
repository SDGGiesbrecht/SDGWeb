/*
 RepositoryStructure.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2018 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

public struct RepositoryStructure {

    // MARK: - Initialization

    public init(_main main: String = #file) {
        var url = URL(fileURLWithPath: main)
        for _ in 1 ... 3 {
            url.deleteLastPathComponent()
        }
        self.init(root: url)
    }

    public init(
        root: URL,
        template: URL? = nil,
        result: URL? = nil,
        pages: URL? = nil,
        components: URL? = nil,
        css: URL? = nil,
        frame: URL? = nil,
        siteCSS: URL? = nil) {

        self.root = root

        let resolvedTemplate = template ?? root.appendingPathComponent("Template")
        self.template = resolvedTemplate

        self.result = result ?? root.appendingPathComponent("Result")

        self.pages = pages ?? resolvedTemplate.appendingPathComponent("Pages")
        let resolvedComponents = components ?? resolvedTemplate.appendingPathComponent("Components")
        self.components = resolvedComponents
        let resolvedCSS = css ?? resolvedTemplate.appendingPathComponent("CSS")
        self.css = resolvedCSS

        self.frame = frame ?? resolvedComponents.appendingPathComponent("Frame.html")
        self.siteCSS = siteCSS ?? resolvedCSS.appendingPathComponent("Site.css")
    }

    // MARK: - Properties

    public let root: URL

    public let template: URL
    public let result: URL

    public let pages: URL
    public let css: URL
    public let components: URL

    public let frame: URL
    public let siteCSS: URL
}