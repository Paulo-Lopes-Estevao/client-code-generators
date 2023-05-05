import 'package:client_code_generators/src/code/dart-http/headers.dart';
import 'package:test/test.dart';

void main() {
  Headers header = Headers();

  group('parseHeaders', () {
    test('returns empty string when headers array is empty', () {
      final headers = [];
      final result = header.parseHeaders(headers, true);
      expect(result, '');
    });

    test('returns valid header string when headers array is not empty', () {
      final headers = [
        {'key': 'Content-Type', 'value': 'application/json', 'disabled': false},
        {'key': 'Authorization', 'value': 'Bearer my-token', 'disabled': true},
        {'key': 'X-Custom-Header', 'value': 'custom-value', 'disabled': false},
      ];
      final expectedOutput = 'var headers = {\n    \'Content-Type\': \'application/json\',\n    \'X-Custom-Header\': \'custom-value\'\n};\n';
      final result = header.parseHeaders(headers, true);
      expect(result, expectedOutput);
    });

    test(
        'returns valid header string when headers array contains only disabled headers',
        () {
      final headers = [
        {'key': 'Authorization', 'value': 'Bearer my-token', 'disabled': true},
        {'key': 'X-Custom-Header', 'value': 'custom-value', 'disabled': true},
      ];
      final result = header.parseHeaders(headers, true);
      expect(result, 'var headers = {\n\n};\n');
    });
  });
}
