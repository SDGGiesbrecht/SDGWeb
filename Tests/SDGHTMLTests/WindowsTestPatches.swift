#if os(Windows)

  // #workaround(SDGCornerstone 5.4.1, Requires newline normalization.)
  public func testFileConvertibleConformance<T>(
    of instance: T,
    uniqueTestName: StrictString,
    file: StaticString = #file,
    line: UInt = #line
  ) where T: Equatable, T: FileConvertible {}

#endif
