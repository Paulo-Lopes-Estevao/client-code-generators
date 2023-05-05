import 'package:client_code_generators/src/lib/request.dart';
import 'package:test/test.dart';

void main() {
  test('request GET not body', () async {
    final request =
        Request('GET', 'https://jsonplaceholder.typicode.com/users');
        final requestBody = await request.requestBody();
    expect(requestBody.bodyFields, {});
  });

  test('request POST body raw', () async {
    final request = Request(
        'POST', 'https://jsonplaceholder.typicode.com/users');
    final requestBody = await request.requestBody(
        body: RequestBody.fields({
      'mode': 'raw',
      'raw': {"userId": 1000, "id": 10, "title": "jogo", "body": "SONIC"}
    }));
    expect(requestBody.bodyFields["raw"], '{"userId":1000,"id":10,"title":"jogo","body":"SONIC"}');
  });

  test('request POST body not raw mode', () async {
    final request = Request(
        'POST', 'https://jsonplaceholder.typicode.com/users');
    final requestBody = await request.requestBody(
        body: RequestBody.fields(
            {"userId": 1000, "id": 10, "title": "jogo", "body": "SONIC"}));
    expect(requestBody.bodyFields, {'userId': '1000', 'id': '10', 'title': 'jogo', 'body': 'SONIC'});
  });
}
