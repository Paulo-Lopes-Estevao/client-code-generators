abstract class IBody {
  String parseRawBody(
      dynamic body, String? contentType, bool trim, int indentCount);
  dynamic parseBody(dynamic body, String? contentType, bool trim, int indent);
  dynamic parseUrlEncoded(Map<String, dynamic> body, String indent, bool trim);
}
