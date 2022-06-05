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
    this.platformID,
    this.encodingID,
    this.languageID,
    this.nameID,
    this.stringLength,
    this.stringOffset,
    this.name,
    this.hexOffset,
  });
}
