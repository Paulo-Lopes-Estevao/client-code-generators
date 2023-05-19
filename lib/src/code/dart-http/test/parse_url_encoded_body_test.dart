import 'package:client_code_generators/src/code/dart-http/data_body.dart';
import 'package:test/test.dart';

void main() {
  var dataBody = DataBody();

  test('should use parse url encoded body disabled false', () {
    var body = {
      "mode": "urlencoded",
      "urlencoded": [
        {"key": "name", "value": "body", "disabled": false}
      ]
    };
    var contentType = 'application/x-www-form-urlencoded';
    var raw = dataBody.parseBody(body, contentType, false, 2);
    expect(raw, 'request.bodyFields = {\n  \'name\': \'body\'\n};');
  });

  test('should use parse url encoded body disabled true', () {
    var body = {
      "mode": "urlencoded",
      "urlencoded": [
        {"key": "name", "value": "body", "disabled": true}
      ]
    };
    var contentType = 'application/x-www-form-urlencoded';
    var raw = dataBody.parseBody(body, contentType, false, 2);
    expect(raw, 'request.bodyFields = {};');
  });

}
