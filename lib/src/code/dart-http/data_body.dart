import 'dart:convert';
import 'package:client_code_generators/src/code/dart-http/config.dart';
import 'package:client_code_generators/src/shared/body.interface.dart';

class DataBody implements IBody {
  /// Parses Raw data
  ///
  /// @param {Object} body Raw body data
  ///
  /// @param {String} contentType the content-type of request body
  ///
  /// @param {Integer} indentCount the number of space to use
  ///
  /// @param {Boolean} trim indicates whether to trim string or not
  ///
  @override
  String parseRawBody(body, String? contentType, bool trim, int indentCount) {
    try {
      if (contentType != null &&
          (contentType == 'application/json' ||
              contentType.endsWith('+json'))) {
        JsonEncoder encoder = JsonEncoder.withIndent(' ' * indentCount);
        var encodedJsonBody = encoder.convert(body);
        var jsonBody = jsonDecode(encodedJsonBody);
        print(jsonBody);
        return 'request.body = json.encode($jsonBody);';
      }
    } catch (e) {
      print(e);
    }

    return "request.body = '''${sanitize(body, trim: trim)}''';";
  }

  /// Parses Url encoded data
  ///
  /// @param {Object} body body data
  /// 
  /// @param {String} indent indentation required for code snippet
  /// 
  /// @param {Boolean} trim indicates whether to trim string or not
  @override
  String parseUrlEncoded(Map<String, dynamic> body, String indent, bool trim) {
    String bodySnippet = 'request.bodyFields = {';
  List<Map<String, dynamic>> enabledBodyList = reject(body, 'disabled');
  List<String> bodyDataMap;

  if (enabledBodyList.isNotEmpty) {
    bodyDataMap = enabledBodyList.map((value) {
      return '$indent\'${sanitize(value['key'], trim: trim)}\': \'${sanitize(value['value'], trim: trim)}\'';
    }).toList();

    bodySnippet += '\n${bodyDataMap.join(',\n')}\n';
  }

  bodySnippet += '};';
  return bodySnippet;
  }

  /// Parses Body from the Request
  ///
  /// @param {Object} body body object from request.
  ///
  /// @param {String} contentType the content-type of the request body
  ///
  @override
  dynamic parseBody(body, String? contentType, bool trim, int indent) {
    if (!isEmpty(body)) {
      switch (body['mode']) {
        case "raw":
          return parseRawBody(body['raw'], contentType, trim, indent);
        case "urlencoded":
          return parseUrlEncoded(body['urlencoded'], ' ' * indent, trim);
        default:
          return "";
      }
    }
    return "";
  }
}
