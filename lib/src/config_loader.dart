import 'dart:io';
import 'package:yaml/yaml.dart';

/// Loads the config file and returns the config object.
class ConfigLoader {
  static final ConfigLoader _instance = ConfigLoader._internal();

  /// 설정 파일이 준비가 되어있는지 판단하는 변수
  bool _isReady = false;
  dynamic _slots = YamlMap();

  factory ConfigLoader() => _instance;

  ConfigLoader._internal() {}

  bool get ready => _isReady;
  dynamic get items => _slots;
  dynamic get message => _slots['message'];

  /// `config.yaml` 파일을 비동기로 읽습니다.
  Future<void> readConfigFile() async {
    try {
      var configFile =
          [Directory.current.path, 'lib/common/config.yaml'].join('/');
      if (!File(configFile).existsSync()) {
        throw Exception('Config file not found: $configFile');
      }

      var config = await File(configFile).readAsString();
      _slots = loadYaml(config);

      if (_slots == null) {
        throw Exception('Config file is empty: $configFile');
      }

      _isReady = true;
    } catch (e) {
      print(e.toString());
    }
  }
}
