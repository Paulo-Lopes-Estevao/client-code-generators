import 'package:client_code_generators/src/language.dart';
import 'package:client_code_generators/src/lib/request.dart';


void convert(language, variant, request, options, void Function(String?, String?) callback) {

  var convert;

  if (request is! Request) {
    return callback('Codegen~convert: Invalid request', null);
  }

  languageMap.forEach((element) {
    if (element['lang'] == language && element['variant'] == variant) {
      convert = element['convert'];
    }
  });

  if (options is! Map<String, dynamic>) {
    return callback('Codegen~convert: Invalid options', null);
  }

  try {
    convert.convert(request, options, (err, snippet) {
      if (err != null) {
        return callback(err, null);
      }

      return callback(null, snippet);
    });
  } catch (e) {
    return callback(e.toString(), null);
  }
}
