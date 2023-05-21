abstract class IBody {
  String parseRawBody(
      dynamic body, String? contentType, bool trim, int indentCount);
  dynamic parseBody(dynamic body, String? contentType, bool trim, int indent);
  dynamic parseUrlEncoded(dynamic body, String indent, bool trim);
}
