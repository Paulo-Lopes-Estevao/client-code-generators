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
        default:
          return "";
      }
    }
    return "";
  }
}
