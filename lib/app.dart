import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

class App<T extends List<String>> {
  final _parser = ArgParser()..addOption('font', abbr: 'f');

  T? arguments;

  App(T arguments) {
    this.arguments = arguments;
  }

  void start() {
    var result = _parser.parse(arguments!);

    if (!result.wasParsed('font')) {
      throw Exception(
          'Usage: dart bin/dart_font_parser.dart --font <font_file>');
    }
    // ignore: unused_local_variable
    for (var arg in result.arguments) {
      downloadFont(result['font']);
    }
  }

  void downloadFont(String fontName) async {
    var uri = Uri.parse(
        'https://github.com/biud436/font-parser/raw/main/res/NanumGothicCoding.ttf');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    var dir = Directory('fonts');
    if (!await dir.exists()) {
      await dir.create();
    }

    await response.pipe(File('fonts/NanumGothicCoding.ttf').openWrite());
  }
}
