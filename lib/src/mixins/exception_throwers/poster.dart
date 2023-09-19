import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/http_status.dart';

mixin MinRestPoster {
  String get baseUrl;

  ///Post a [data] object to the [uri] endpoint.
  ///[uri] is resource path after the base url.
  ///Pass your [dataModel.toJson] as [data].
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  Future<M> post<M>(
      String uri, Map<String, dynamic> data, M Function(Map<String, dynamic> json) deSerializer,
      {String token = ""}) async {

    http.Response res = await http.post(
      Uri.parse(baseUrl + uri),
      headers: {
        "Authorization" : "Bearer $token",
        "Content-Type" : "application/json"
      },
      body: jsonEncode(data)
    );
    if (HttpStatus.isSuccess(res.statusCode)) {
      return deSerializer(jsonDecode(res.body));
    } else {
      throw Exception("Error: ${res.statusCode} : ${res.body} ${res.request}");
    }
  }
}
