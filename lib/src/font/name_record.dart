import 'font.dart' show Font;

/// [NameRecord] 클래스는 [Font] 클래스에서 중요하게 사용됩니다.
class NameRecord {
  int? platformID = 0;
  int? encodingID = 0;
  int? languageID = 0;
  int? nameID = 0;
  int? stringLength = 0;
  int? stringOffset = 0;
  String? name = '';
  int? hexOffset = 0;

  NameRecord({
    required this.platformID,
    required this.encodingID,
    required this.languageID,
    required this.nameID,
    required this.stringLength,
    required this.stringOffset,
    required this.name,
    this.hexOffset,
  });
}
