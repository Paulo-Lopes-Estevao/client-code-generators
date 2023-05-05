import 'package:client_code_generators/src/code/dart-http/data_body.dart';
import 'package:test/test.dart';

void main() {
  var dataBody = DataBody();

  test('should use parse not raw body', () {
    var body = '{"name": "body"}';
    var contentType = 'application/json';
    var raw = dataBody.parseRawBody(body, contentType, true, 4);
    expect(raw, 'request.body = json.encode({"name": "body"});');
  });

  test('should use parse raw body', () {
    var body = {"mode": "raw", "raw": '{"name": "body"}'};
    var contentType = 'application/json';
    var raw = dataBody.parseBody(body, contentType, true, 4);
    expect(raw, 'request.body = json.encode({"name": "body"});');
  });
}
