/*
 SiteSyntaxUnfolder.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2020–2024 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import SDGHTML

/// A syntax unfolder used for site generation.
public protocol SiteSyntaxUnfolder: SyntaxUnfolderProtocol {

  /// Creates a syntax unfolder with the provided context.
  ///
  /// - Parameters:
  ///   - context: Context information.
  init(context: SyntaxUnfolder.Context)
}
