/// OffsetTable
/// 트루타입 폰트에서 이름 테이블을 파싱하기 위해 테이블 갯수 등의 정보를 보관합니다.
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
