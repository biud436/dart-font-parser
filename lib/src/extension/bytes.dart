import 'dart:convert';
import 'dart:typed_data';

extension ByteEx on String {
  int readU16BE(int offset) {
    var startOffset = offset * 2;
    var endOffset = startOffset + 4;
    return int.parse(substring(startOffset, endOffset), radix: 16);
  }

  int readU16LE(int offset) {
    var startOffset = offset * 2;
    var endOffset = startOffset + 2;
    final HIBYTE = substring(startOffset, endOffset + 2);
    final LOBYTE = substring(endOffset + 2, endOffset + 4);
    return int.parse(HIBYTE + LOBYTE, radix: 16);
  }
}

extension HexEx on Uint8List {
  String toHex() {
    return map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}

Iterable<int> range(int low, int high) sync* {
  for (var i = low; i < high; ++i) {
    yield i;
  }
}
