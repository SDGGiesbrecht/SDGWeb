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
  static let root = String(
    data: Data(
      base64Encoded:
        "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBTREdXZWIgb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vc2RnZ2llc2JyZWNodC5naXRodWIuaW8vU0RHV2ViCgogQ29weXJpZ2h0IMKpMjAxOOKAkzIwMTkgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBTREdXZWIgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogKi8KCi8qIExheW91dCAqLwoKaHRtbCwgYm9keSB7CiAgICBtYXJnaW46IDA7CiAgICBwYWRkaW5nOiAwOwp9CgovKiBDb2xvdXJzICovCgpodG1sIHsKICAgIGJhY2tncm91bmQtY29sb3I6ICNGRkZGRkY7CiAgICBjb2xvcjogIzAwMDAwMDsKfQoKLyogRm9udHMgKi8KCmh0bWwgewogICAgZm9udC1mYW1pbHk6IHNlcmlmOwp9CkBtZWRpYSBvbmx5IHNjcmVlbiB7CiAgICBodG1sIHsKICAgICAgICBmb250LWZhbWlseTogc2Fucy1zZXJpZjsKICAgIH0KfQoKLyogU2VtYW50aWMgVGV4dCBGb3JtYXR0aW5nICovCgpzcGFuW2xhbmddIHsgLyogRm9yZWlnbiBsYW5ndWFnZS4gKi8KICAgIGZvbnQtc3R5bGU6IGl0YWxpYzsKfQo="
    )!,
    encoding: String.Encoding.utf8
  )!

}
