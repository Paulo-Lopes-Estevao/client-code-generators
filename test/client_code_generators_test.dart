import 'package:client_code_generators/src/index.dart';
import 'package:client_code_generators/src/lib/request.dart';
import 'package:test/test.dart';

void main() {

  test('return dart language codegen using GET request', () {
    final request =
        Request('GET', 'https://jsonplaceholder.typicode.com/users');

    var options = {
      'trimRequestBody': true,
      'indentType': 'Space',
      'indentCount': 2,
      'requestTimeout': 0,
      'followRedirect': true,
      'includeBoilerplate': true
    };
    var language = 'Dart';
    var variant = 'http';
    
    convert(language, variant, request, options, (error, snippet) {
      expect(snippet, isNotNull);
    });
  });

}
