import 'package:client_code_generators/src/code/dart-http/data_body.dart';
import 'package:client_code_generators/src/code/dart-http/headers.dart';
import 'package:client_code_generators/src/code/dart-http/index.dart';
import 'package:client_code_generators/src/lib/request.dart';
import 'package:test/test.dart';

void main() {
  test('request GET convert template', () async {
    final request =
        Request('GET', 'https://jsonplaceholder.typicode.com/users');

    ConvertTemplate convertTemplate = ConvertTemplate(DataBody(), Headers());
    var options = {
      'trimRequestBody': true,
      'indentType': 'Space',
      'indentCount': 2,
      'requestTimeout': 0,
      'followRedirect': true,
      'includeBoilerplate': true
    };
    convertTemplate.convert(request, options, (error, snippet) {
      print(snippet);
      expect(snippet, isNotNull);
    });
  });

  test('request POST convert template', () async {
    var request = Request('POST', 'https://jsonplaceholder.typicode.com/users');
    final headers = [
      {'key': 'Content-Type', 'value': 'application/json', 'disabled': false},
    ];
    var requestbody = await request.requestBody(
        header: headers,
        body: RequestBody.fields({
          'mode': 'raw',
          'raw': {
              "userId": 1000,
              "id": 10, 
              "title": "jogo", 
              "body": "SONIC"
            }
        }));

    ConvertTemplate convertTemplate = ConvertTemplate(DataBody(), Headers());
    var options = {
      'trimRequestBody': true,
      'indentType': 'Space',
      'indentCount': 2,
      'requestTimeout': 0,
      'followRedirect': true,
      'includeBoilerplate': true
    };
    convertTemplate.convert(requestbody, options, (error, snippet) {
      print(snippet);
      expect(snippet, isNotNull);
    });
  });
}
