/*
 main.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

  import Foundation

import SDGLogic
import SDGText
import SDGPersistence

  let specificationURL = URL(string: "https://html.spec.whatwg.org/entities.json")!
// #workaround(SDGCornerstone 6.2.0, Web lacks file system interaction.)
#if !os(WASI)
  let json = try Data(from: specificationURL)
  let database = try JSONDecoder().decode([String: Entity].self, from: json)
#endif

var transformed: [String: String] = [:]
// #workaround(SDGCornerstone 6.2.0, Web lacks file system interaction.)
#if !os(WASI)
  for (entity, text) in database {
    var name = entity
    if entity.hasPrefix("&"),
      entity.hasSuffix(";")
    {
      name.removeFirst()
      name.removeLast()
      transformed[name] = text.characters
    }
  }
#endif

var file: [StrictString] = [
  "// This is generated automatically using the generate‐entity‐list target.",
  "@usableFromInline internal let entities: [String: String] = [",
]
let sorted = transformed.sorted(by: { $0 < $1 })
for (entity, text) in sorted {
  let scalars = text.scalars.map({ "\\u{\($0.hexadecimalCode)}" }).joined()
  var line: StrictString = "  \u{22}\(entity)\u{22}: \u{22}\(scalars)\u{22}"
  if entity ≠ sorted.last?.0 {
    line.append(",")
  }
  file.append(line)
}
file.append("]\n")

  let sourceFile = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .appendingPathComponent("SDGHTML")
    .appendingPathComponent("Entities.swift")

// #workaround(SDGCornerstone 6.2.0, Web lacks file system interaction.)
#if !os(WASI)
  var existing = try StrictString(from: sourceFile)
  existing.truncate(after: "*/\n\n")
  existing.append(contentsOf: file.joined(separator: "\n".scalars))
  try existing.save(to: sourceFile)
#endif
