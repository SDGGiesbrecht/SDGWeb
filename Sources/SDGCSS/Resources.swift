/*
 Resources.swift

 This source file is part of the SDGWeb open source project.
 https://sdggiesbrecht.github.io/SDGWeb

 Copyright ©2019–2020 Jeremy David Giesbrecht and the SDGWeb project contributors.

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
        "LyoKIFJvb3QuY3NzCgogVGhpcyBzb3VyY2UgZmlsZSBpcyBwYXJ0IG9mIHRoZSBTREdXZWIgb3BlbiBzb3VyY2UgcHJvamVjdC4KIGh0dHBzOi8vc2RnZ2llc2JyZWNodC5naXRodWIuaW8vU0RHV2ViCgogQ29weXJpZ2h0IMKpMjAxOOKAkzIwMTkgSmVyZW15IERhdmlkIEdpZXNicmVjaHQgYW5kIHRoZSBTREdXZWIgcHJvamVjdCBjb250cmlidXRvcnMuCgogU29saSBEZW8gZ2xvcmlhLgoKIExpY2Vuc2VkIHVuZGVyIHRoZSBBcGFjaGUgTGljZW5jZSwgVmVyc2lvbiAyLjAuCiBTZWUgaHR0cDovL3d3dy5hcGFjaGUub3JnL2xpY2Vuc2VzL0xJQ0VOU0UtMi4wIGZvciBsaWNlbmNlIGluZm9ybWF0aW9uLgogKi8KCi8qIOKAouKAouKAouKAouKAouKAouKAoiBMYXlvdXQg4oCi4oCi4oCi4oCi4oCi4oCi4oCiICovCgovKiBGaWxsIHZpZXdwb3J0ICovCmh0bWwsIGJvZHkgewogIG1hcmdpbjogMDsKICBwYWRkaW5nOiAwOwogIG1pbi13aWR0aDogMTAwdnc7CiAgbWluLWhlaWdodDogMTAwdmg7Cn0KCi8qIFJlbW92ZSBuYXZpZ2F0aW9uIGZyb20gcHJpbnQgKi8KQG1lZGlhIHByaW50IHsKICBuYXYgewogICAgZGlzcGxheTogbm9uZTsKICB9Cn0KCi8qIFRyZWF0IG5hdmlnYXRpb24gbGlua3MgYXMgYmxvY2sgZWxlbWVudHMgKi8KbmF2ID4gYSB7CiAgICBkaXNwbGF5OiBibG9jazsKfQoKLyogQm9va+KAkHN0eWxlIHBhcmFncmFwaHMgKi8KcCB7CiAgdGV4dC1pbmRlbnQ6IDNlbTsKfQpwIHsKICB0ZXh0LWFsaWduOiBqdXN0aWZ5OwogIGh5cGhlbnM6IGF1dG87Cn0KCnAgewogIG1hcmdpbi1ib3R0b206IDBlbTsKICBtYXJnaW4tdG9wOiAwZW07Cn0KOm5vdChwKSArIHAgewogIG1hcmdpbi10b3A6IDAuNWVtOwp9CnAgKyA6bm90KHApIHsKICBtYXJnaW4tdG9wOiAwLjVlbTsKfQpwOmxhc3QtY2hpbGQgewogIG1hcmdpbi1ib3R0b206IDAuNWVtOwp9CgovKiDigKLigKLigKLigKLigKLigKLigKIgQ29sb3VycyDigKLigKLigKLigKLigKLigKLigKIgKi8KCi8qIFN0YW5kYXJkaXplIGNvbG91cnMgKi8KaHRtbCB7CiAgYmFja2dyb3VuZC1jb2xvcjogI0ZGRkZGRjsKICBjb2xvcjogIzAwMDAwMDsKfQoKLyogUmVtb3ZlIGxpbmtzIGZyb20gcHJpbnQgKi8KQG1lZGlhIHByaW50IHsKICBhIHsKICAgIGNvbG9yOiBpbmhlcml0OwogIH0KfQoKLyog4oCi4oCi4oCi4oCi4oCi4oCi4oCiIEZvbnRzIOKAouKAouKAouKAouKAouKAouKAoiAqLwoKaHRtbCB7CiAgZm9udC1mYW1pbHk6IHNlcmlmOwp9CkBtZWRpYSBvbmx5IHNjcmVlbiB7CiAgaHRtbCB7CiAgICBmb250LWZhbWlseTogc2Fucy1zZXJpZjsKICB9Cn0KCi8qIOKAouKAouKAouKAouKAouKAouKAoiBTZW1hbnRpYyBUZXh0IEZvcm1hdHRpbmcg4oCi4oCi4oCi4oCi4oCi4oCi4oCiICovCgpzcGFuLmZvcmVpZ24sIHNwYW4uZnJlbWQgeyAvKiA8Zm9yZWlnbj46IEZvcmVpZ24gbGFuZ3VhZ2UuICovCiAgZm9udC1zdHlsZTogaXRhbGljOwp9CgovKiBSZW1vdmUgbGlua3MgZnJvbSBwcmludCAqLwpAbWVkaWEgcHJpbnQgewogIGEgewogICAgZm9udC13ZWlnaHQ6IGluaGVyaXQ7CiAgICB0ZXh0LWRlY29yYXRpb246IGluaGVyaXQ7CiAgfQp9Cg=="
    )!,
    encoding: String.Encoding.utf8
  )!

}
