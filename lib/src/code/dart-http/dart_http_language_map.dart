import 'package:client_code_generators/src/code/dart-http/data_body.dart';
import 'package:client_code_generators/src/code/dart-http/headers.dart';
import 'package:client_code_generators/src/code/dart-http/index.dart';

Map<String, dynamic> dartHttpLanguageMap = {
    "type": "code_generator",
    "lang": "Dart",
    "variant": "http",
    "convert": ConvertTemplate(DataBody(), Headers()),
    "syntax_mode": "dart"
};