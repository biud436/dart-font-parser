import 'package:dart_font_parser/app.dart';

void main(List<String> arguments) {
  try {
    var app = App(arguments);
    app.start();
  } on Exception {
    print('Usage: dart_font_parser.dart --font <font_file>');
  }
}
