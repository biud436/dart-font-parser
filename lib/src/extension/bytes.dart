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
    return int.parse(LOBYTE + HIBYTE, radix: 16);
  }
}

extension HexEx on Uint8List {
  String toHex() {
    return map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  int readU16BE(int startOffset, int endOffset) {
    return int.parse(sublist(startOffset, endOffset).toHex(), radix: 16);
  }  
}
