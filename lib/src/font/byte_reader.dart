import 'dart:typed_data';

class MyByteReader {
  static final MyByteReader _instance = MyByteReader._internal();

  factory MyByteReader() => _instance;

  MyByteReader._internal() {}
}
