import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dart_font_parser/src/font/offset_table.dart';
import 'name_record.dart';
import '../extension/bytes.dart';
import 'dart:convert' show utf8;

class Font {
  String? fontName;
  List<String>? fonts = [];

  Font({this.fontName});

  Future<void> parse() async {
    try {
      var name = fontName!.trim();

      print(name);

      var file = File('fonts/$name.ttf');
      if (!file.existsSync()) {
        throw Exception('Font file not found: $name');
      }
      var position = 0;
      var bytes = await file.readAsBytes();
      var hex = bytes.toHex();
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
        var checkSum = int.parse(
            bytes.sublist(position + 4, position + 8).toHex(),
            radix: 16);
        var offset = int.parse(
            bytes.sublist(position + 8, position + 12).toHex(),
            radix: 16);
        var length = int.parse(
            bytes.sublist(position + 12, position + 16).toHex(),
            radix: 16);

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
        throw Exception('이름 테이블을 찾지 못했습니다.');
      }

      position = nameTableOffset;

      var formatSelector =
          int.parse(bytes.sublist(position, position + 2).toHex(), radix: 16);
      var nameRecordCount = int.parse(
          bytes.sublist(position + 2, position + 4).toHex(),
          radix: 16);
      var storageOffset = int.parse(
          bytes.sublist(position + 4, position + 6).toHex(),
          radix: 16);

      print(
          'formatSelector: $formatSelector. nameRecordCount: $nameRecordCount. storageOffset: $storageOffset');

      // 6바이트 seek 처리
      position += 6;

      if (formatSelector != 0) {
        print('이름 테이블이 감지되었습니다.');
      }

      var nameRecords = <NameRecord>[];

      for (final i in range(0, nameRecordCount)) {
        var record = NameRecord(
            platformID: int.parse(bytes.sublist(position, position + 2).toHex(),
                radix: 16),
            encodingID: int.parse(
                bytes.sublist(position + 2, position + 4).toHex(),
                radix: 16),
            languageID: int.parse(
                bytes.sublist(position + 4, position + 6).toHex(),
                radix: 16),
            nameID: int.parse(bytes.sublist(position + 6, position + 8).toHex(),
                radix: 16),
            stringLength: int.parse(
                bytes.sublist(position + 8, position + 10).toHex(),
                radix: 16),
            stringOffset: int.parse(
                bytes.sublist(position + 10, position + 12).toHex(),
                radix: 16),
            name: '');

        if (record.nameID! == 4) {
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
        print('이 폰트의 이름은 {0} 입니다'.replaceAll('{0}', record.name!));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
