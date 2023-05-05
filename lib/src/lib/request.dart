import 'dart:convert';

class RequestBody {
  final Map<String, dynamic> _fields;

  RequestBody.raw(String raw) : _fields = {'mode': 'raw', 'raw': json.encode(raw)};

  RequestBody.fields(Map<String, dynamic> fields) : _fields = fields;

  Map<String, dynamic> toMap() {
    return _fields.map((key, value) {
      if (key == 'raw' && value is Map) {
        value = jsonEncode(value);
      }
      return MapEntry(key, value.toString());
    });
  }
}

class Request extends RequestBase {
  Request(super.method, super.url);

  Future<RequestBase> requestBody({
    RequestBody? body,
    List<Map<String, Object>>? header
  }) async {
    final request = RequestBase(method, url);
    if (body != null) {
      request.bodyFields = body.toMap();
    }
    if(header != null){
      request.header = header;
    }

    return request;
    
  }

  
}

class RequestBase {
  final String url;
  final String method;
  static Map<String, dynamic> _bodyFields = <String, dynamic>{};
  static List<Map<String, Object>> _headers = <Map<String, Object>>[];

  RequestBase(
     this.method,
     this.url,
  );

   void set bodyFields(Map<String, dynamic> fields) {
      _bodyFields = fields;
   }

  Map<String, dynamic> get bodyFields {
    return _bodyFields;
  }

  void set header(List<Map<String, Object>> fields){
    _headers = fields;
  }

  List<Map<String, Object>> get header {
    return _headers;
  }


}