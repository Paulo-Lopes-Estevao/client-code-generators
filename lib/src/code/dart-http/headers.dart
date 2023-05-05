import 'package:client_code_generators/src/code/dart-http/config.dart';
import 'package:client_code_generators/src/shared/header.interface.dart';

class Headers implements IHeaders {
  static const indentCount = 4;
  static const indent = '    ';

  /// Parses headers from the request.
  ///
  /// @param {Object} headersArray array containing headers
  ///
  /// @param {Boolean} trim indicates whether to trim string or not
  ///
  @override
  String parseHeaders(List headersArray, bool trim) {
    var headerString = '';
    List<dynamic> headerDictionary = [];

    if (isEmpty(headersArray)) {
      return headerString;
    }

    headerString += 'var headers = {\n';

    forEach(headersArray, (header) {
      if (!header['disabled']) {
        headerDictionary
            .add("$indent'${header['key']}': '${sanitize(header['value'])}'");
      }
    });

    headerString += headerDictionary.join(',\n');
    headerString += '\n};\n';

    return headerString;
  }
}
