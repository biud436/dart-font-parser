class OffsetTable {
  int? majorVersion;
  int? minorVersion;
  int? numTables;
  int? padding;

  OffsetTable({
    required this.majorVersion,
    required this.minorVersion,
    required this.numTables,
    required this.padding,
  });

  @override
  String toString() {
    return 'OffsetTable{majorVersion: $majorVersion, minorVersion: $minorVersion, numTables: $numTables, padding: $padding}';
  }
}
