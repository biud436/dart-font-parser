import 'dart:io';
import 'package:yaml/yaml.dart';
import 'dart:developer';

///
/// Loads the config file and returns the config object.
///
class ConfigLoader {
  static final ConfigLoader _instance = ConfigLoader._internal();

  bool _isReady = false;
  dynamic _slots = YamlMap();

  factory ConfigLoader() => _instance;

  ConfigLoader._internal() {}

  bool get ready => _isReady;
  dynamic get items => _slots;

  Future<void> readConfigFile() async {
    try {
      var configFile =
          [Directory.current.path, "lib/common/config.yaml"].join('/');
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
      log(e.toString());
    }
  }
}
