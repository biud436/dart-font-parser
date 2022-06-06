import 'dart:io';
import 'package:dart_font_parser/src/config_loader.dart';
import 'package:dart_font_parser/src/font/offset_table.dart';
import 'name_record.dart';
import '../extension/bytes.dart';
import '../utils/range.dart';

/// 폰트를 파싱하는 클래스
/// * `fontName`은 필수입니다.
class Font {
  String? fontName;
  List<String>? fonts = [];

  Font({required this.fontName});

  Future<void> parse() async {
    try {
      var name = fontName!.trim();

      var file = File('fonts/$name.ttf');
      if (!file.existsSync()) {
        throw Exception('Font file not found: $name');
      }
      var position = 0;
      var bytes = await file.readAsBytes();
      var fontOffsetTableBuffer = bytes.sublist(position, 12).toHex();

      // 12바이트 seek
      position += 12;

      // 오프셋 테이블 파싱
      var offsetTable = OffsetTable(
        majorVersion: fontOffsetTableBuffer.readU16BE(0),
        minorVersion: fontOffsetTableBuffer.readU16BE(2),
        numTables: fontOffsetTableBuffer.readU16BE(4),
        padding: fontOffsetTableBuffer.readU16BE(6),
      );

      if (offsetTable.majorVersion != 1 || offsetTable.minorVersion != 0) {
        throw Exception('This font is not True Type Font');
      }

      var nameTableOffset = 0x00;
      var isFoundNameTable = false;

      var len = offsetTable.numTables;
      for (final i in range(0, len!)) {
        var tagBuffer = bytes
            .sublist(position, position + 4)
            .map((e) => String.fromCharCode(e))
            .join();

        var tagName = tagBuffer;
        var checkSum = bytes.readU16BE(position + 4, position + 8);
        var offset = bytes.readU16BE(position + 8, position + 12);
        var length = bytes.readU16BE(position + 12, position + 16);

        print(
            '$i. tagName: $tagName checkSum: $checkSum, offset: $offset, length: $length');

        position += 16;

        if (tagName == 'name') {
          nameTableOffset = offset;
          isFoundNameTable = true;
          break;
        }
      }

      if (!isFoundNameTable) {
        throw Exception(ConfigLoader().message['NOT_FOUND_NAME_TABLE']);
      }

      position = nameTableOffset;

      var formatSelector = bytes.readU16BE(position, position + 2);
      var nameRecordCount = bytes.readU16BE(position + 2, position + 4);
      var storageOffset = bytes.readU16BE(position + 4, position + 6);

      print(
          'formatSelector: $formatSelector. nameRecordCount: $nameRecordCount. storageOffset: $storageOffset');

      // 6바이트 seek 처리
      position += 6;

      if (formatSelector != 0) {
        print(ConfigLoader().message['DETECT_NAME_TABLE']);
      }

      var nameRecords = <NameRecord>[];

      for (final i in range(0, nameRecordCount)) {
        var record = NameRecord(
            platformID: bytes.readU16BE(position, position + 2),
            encodingID: bytes.readU16BE(position + 2, position + 4),
            languageID: bytes.readU16BE(position + 4, position + 6),
            nameID: bytes.readU16BE(position + 6, position + 8),
            stringLength: bytes.readU16BE(position + 8, position + 10),
            stringOffset: bytes.readU16BE(position + 10, position + 12),
            name: '');

        if (isValidNameID(record.nameID!)) {
          var startOffset =
              nameTableOffset + record.stringOffset! + storageOffset;
          var nameRecordBuffer =
              bytes.sublist(startOffset, startOffset + record.stringLength!);

          record.name =
              nameRecordBuffer.map((e) => String.fromCharCode(e)).join();

          nameRecords.add(record);
        }

        position += 12;
      }

      for (final record in nameRecords) {
        print(ConfigLoader().message['GET_FONT_NAME'].replaceAll('{0}', record.name!));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool isValidNameID(int nameID) {
    return nameID == 4;
  }
}
