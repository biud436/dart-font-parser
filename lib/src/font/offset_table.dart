class OffsetTable {
  int? majorVersion;
  int? minorVersion;
  int? numTables;
  int? padding;

  OffsetTable({
    this.majorVersion,
    this.minorVersion,
    this.numTables,
    this.padding,
  });

  @override
  String toString() {
    return 'OffsetTable{majorVersion: $majorVersion, minorVersion: $minorVersion, numTables: $numTables, padding: $padding}';
  }
}
