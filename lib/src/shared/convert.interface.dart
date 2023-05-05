abstract class IConvert {
  dynamic convert(request, Map<String, dynamic> options,
      void Function(dynamic error, dynamic snippet) callback);
}
