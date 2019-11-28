/*
 Resources.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019 Jeremy David Giesbrecht and the SDGWeb project contributors.

 Soli Deo gloria.

 Licensed under the Apache Licence, Version 2.0.
 See http://www.apache.org/licenses/LICENSE-2.0 for licence information.
 */

import Foundation

internal enum Resources {}
internal typealias Ressourcen = Resources

extension Resources {
  static let redirect = String(
    data: Data(
      base64Encoded:
        "PCFET0NUWVBFIGh0bWw+Cgo8IS0tCiBSZWRpcmVjdC5odG1sCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBTREdXZWIgb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vc2RnZ2llc2JyZWNodC5naXRodWIuaW8vU0RHV2ViCgogQ29weXJpZ2h0IMKpMjAxOOKAkzIwMTkgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBTREdXZWIgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogLS0+Cgo8aHRtbCBsYW5nPSJ6eHgiPgogPGhlYWQ+CiAgPG1ldGEgY2hhcnNldD0idXRmJiN4MDAyRDs4Ij4KICA8dGl0bGU+4oazIFsqcmVhZGFibGUqXTwvdGl0bGU+CiAgPGxpbmsgcmVsPSJjYW5vbmljYWwiIGhyZWY9IlsqZW5jb2RlZCpdIj4KICA8bWV0YSBodHRwLWVxdWl2PSJyZWZyZXNoIiBjb250ZW50PSIwOyB1cmw9WyplbmNvZGVkKl0iPgogPC9oZWFkPgogPGJvZHk+CiAgPHA+4oazIDxhIGhyZWY9IlsqZW5jb2RlZCpdIj5bKnJlYWRhYmxlKl08L2E+CiA8L2JvZHk+CjwvaHRtbD4K"
    )!,
    encoding: String.Encoding.utf8
  )!

}
