import 'dart:cli';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_font_parser/src/config_loader.dart';

import 'src/font/font.dart';

/// 메인 진입점입니다.
class App<T extends List<String>> {
  final _parser = ArgParser()..addOption('font', abbr: 'f');

  T? arguments;

  /// 생성자
  App(T arguments) {
    this.arguments = arguments;
  }

  /// 폰트를 다운로드하고, 폰트 정보를 읽어옵니다.
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

  /// 폰트를 다운로드 받는 함수로 `private`로 선언되어있습니다.
  /// * `fontName` - 폰트의 이름입니다.
  void _downloadFont([String fontName='NanumGothicCoding']) async {
    try {
      var loader = ConfigLoader();

      waitFor(loader.readConfigFile());

      var uri = Uri.parse(loader.items['font']['remotePath']);

      var file = File('fonts/$fontName.ttf');
      if (file.existsSync()) {
        return;
      }

      final request = await HttpClient().getUrl(uri);
      final response = await request.close();

      // 폰트 폴더가 없으면 새로 생성합니다.
      var dir = Directory('fonts');
      if (!await dir.exists()) {
        await dir.create();
      }

      await response.pipe(File(loader.items['font']['localPath']).openWrite());
    } catch (e) {
      print(e.toString());
    }
  }
}
