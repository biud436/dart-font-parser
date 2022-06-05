import 'dart:cli';
import 'dart:developer';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_font_parser/src/config_loader.dart';

import 'src/font/font.dart';

/// The main entry point for the application.
class App<T extends List<String>> {
  final _parser = ArgParser()..addOption('font', abbr: 'f');

  T? arguments;

  App(T arguments) {
    this.arguments = arguments;
  }

  void start() async {
    var result = _parser.parse(arguments!);

    if (!result.wasParsed('font')) {
      throw Exception(
          'Usage: dart bin/dart_font_parser.dart --font <font_file>');
    }
    // ignore: unused_local_variable
    for (var arg in result.arguments) {
      _downloadFont(result['font']);
    }

    var fontParser = Font(fontName: result['font']);

    await fontParser.parse();
  }

  void _downloadFont(String fontName) async {
    try {
      var loader = ConfigLoader();

      waitFor(loader.readConfigFile());

      print(loader.items['font']);

      var uri = Uri.parse(loader.items['font']['remotePath']);

      var file = File('fonts/$fontName.ttf');
      if (file.existsSync()) {
        return;
      }

      final request = await HttpClient().getUrl(uri);
      final response = await request.close();

      var dir = Directory('fonts');
      if (!await dir.exists()) {
        await dir.create();
      }

      await response.pipe(File(loader.items['font']['localPath']).openWrite());
    } catch (e) {
      log(e.toString());
    }
  }
}
