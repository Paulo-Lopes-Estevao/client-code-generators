import 'package:client_code_generators/src/code/dart-http/config.dart';
import 'package:client_code_generators/src/shared/body.interface.dart';
import 'package:client_code_generators/src/shared/convert.interface.dart';
import 'package:client_code_generators/src/shared/header.interface.dart';

class ConvertTemplate implements IConvert {
  final IBody _body;
  final IHeaders _headers;

  ConvertTemplate(this._body, this._headers);

  @override
  dynamic convert(request, Map<String, dynamic> options,
      void Function(dynamic error, dynamic snippet) callback) {
    var indent = '',
        codeSnippet = '',
        headerSnippet = '',
        footerSnippet = '',
        trim = false,
        timeout = 0,
        followRedirect = false,
        // ignore: prefer_typing_uninitialized_variables
        contentType;
    var optionsRequest = sanitizeOptions(options, getOptions());

    trim = optionsRequest['trimRequestBody'];
    indent = optionsRequest['indentType'] == 'Tab' ? '\t' : ' ';
    indent = indent * optionsRequest['indentCount'];
    timeout = optionsRequest['requestTimeout'];
    followRedirect = optionsRequest['followRedirect'];

    if (!isFunction(callback)) {
      throw ArgumentError('callback is not a function');
    }

    if (request.bodyFields == null &&
        !request.header.any((header) => header.containsKey('Content-Type'))) {
      if (request.bodyFields["mode"] == "graphql") {
        request.header.addAll({'Content-Type': 'application/json'});
      } else if (request.bodyFields["mode"] == "file") {
        request.header.addAll({'Content-Type': 'text/plain'});
      }
    }

    final headerType = {
      for (var header in request.header)
        header['key'] as String: header['value'] as String
    };
    contentType = headerType['Content-Type'];
    if (optionsRequest['includeBoilerplate']) {
      if (contentType != null &&
          (contentType == 'application/json' ||
              contentType.endsWith('+json'))) {
        headerSnippet = 'import \'dart:convert\';\n';
      }

      headerSnippet += 'import \'package:http/http.dart\' as http;\n\n';
      headerSnippet += 'void main() async {\n';
      footerSnippet = '}\n';
    }

    // The following code handles multiple files in the same formdata param.
    // It removes the form data params where the src property is an array of filepath strings
    // Splits that array into different form data params with src set as a single filepath string
    if (request.bodyFields != null &&
        request.bodyFields['mode'] == 'formdata') {
      List<dynamic> formdata = request.bodyFields['formdata'];
      List<Map<String, dynamic>> formdataArray = [];
      for (var param in formdata) {
        String key = param['key'];
        String type = param['type'];
        bool disabled = param['disabled'] ?? false;
        String contentType = param['contentType'];
        // check if type is file or text
        if (type == 'file') {
          // if src is not of type string we check for array(multiple files)
          if (param['src'] is List<String>) {
            // if src is an array(not empty), iterate over it and add files as separate form fields
            if (param['src'].isNotEmpty) {
              param['src'].forEach((filePath) {
                addFormParam(
                    formdataArray, key, type, filePath, disabled, contentType);
              });
            }
            // if src is not an array or string, or is an empty array, add a placeholder for file path(no files case)
            else {
              addFormParam(formdataArray, key, type, '/path/to/file', disabled,
                  contentType);
            }
          }
          // if src is string, directly add the param with src as filepath
          else if (param['src'] is String) {
            addFormParam(
                formdataArray, key, type, param['src'], disabled, contentType);
          }
        }
        // if type is text, directly add it to formdata array
        else if (type == 'text') {
          addFormParam(
              formdataArray, key, type, param['value'], disabled, contentType);
        }
      }
      request.bodyFields
          .update({'mode': 'formdata', 'formdata': formdataArray});
    }

    final headers = _headers.parseHeaders(request.header, trim),
        requestBody = request.bodyFields ?? {},
        body = _body.parseBody(requestBody, contentType, trim, 2) + '\n';

    codeSnippet += headers;

    if (requestBody.isNotEmpty != null && requestBody['mode'] == 'formdata') {
      codeSnippet +=
          'var request = http.MultipartRequest(\'${request.method.toUpperCase()}\', Uri.parse(\'${request.url.toString()}\'));\n';
    } else {
      codeSnippet +=
          'var request = http.Request(\'${request.method.toUpperCase()}\', Uri.parse(\'${request.url.toString()}\'));\n';
    }

    if (body != '') {
      codeSnippet += body;
    }
    if (headers != '') {
      codeSnippet += 'request.headers.addAll(headers);\n';
    }
    if (!followRedirect) {
      codeSnippet += 'request.followRedirects = false;\n';
    }

    codeSnippet += '\n';

    codeSnippet += 'http.StreamedResponse response = await request.send()';
    if (timeout > 0) {
      codeSnippet += '.timeout(Duration(milliseconds: $timeout))';
    }
    codeSnippet += ';\n\n';
    codeSnippet += 'if (response.statusCode == 200) {\n';
    codeSnippet += '${indent}print(await response.stream.bytesToString());\n';
    codeSnippet += '}\nelse {\n';
    codeSnippet += '${indent}print(response.reasonPhrase);\n';
    codeSnippet += '}\n';

    if (optionsRequest['includeBoilerplate']) {
      codeSnippet = ('$indent${codeSnippet.split('\n').join('\n$indent')}\n');
    }

    callback(null, headerSnippet + codeSnippet + footerSnippet);
  }
}

List<Map<String, dynamic>> getOptions() {
  return [
    {
      'name': 'Set indentation count',
      'id': 'indentCount',
      'type': 'positiveInteger',
      'default': 2,
      'description':
          'Set the number of indentation characters to add per code level'
    },
    {
      'name': 'Set indentation type',
      'id': 'indentType',
      'type': 'enum',
      'availableOptions': ['Tab', 'Space'],
      'default': 'Space',
      'description': 'Select the character used to indent lines of code'
    },
    {
      'name': 'Set request timeout',
      'id': 'requestTimeout',
      'type': 'positiveInteger',
      'default': 0,
      'description':
          'Set number of milliseconds the request should wait for a response' ' before timing out (use 0 for infinity)'
    },
    {
      'name': 'Trim request body fields',
      'id': 'trimRequestBody',
      'type': 'boolean',
      'default': false,
      'description':
          'Remove white space and additional lines that may affect the server\'s response'
    },
    {
      'name': 'Include boilerplate',
      'id': 'includeBoilerplate',
      'type': 'boolean',
      'default': false,
      'description': 'Include class definition and import statements in snippet'
    },
    {
      'name': 'Follow redirects',
      'id': 'followRedirect',
      'type': 'boolean',
      'default': true,
      'description': 'Automatically follow HTTP redirects'
    }
  ];
}
