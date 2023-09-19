import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:minimal_rest/src/core/http_status.dart';

mixin MinRestGetter{
  String get baseUrl;

  ///Get a [M] object from the [uri] endpoint.
  ///[uri] is resource path after the base url.
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  Future<M> get<M>(String uri, M Function(Map<String, dynamic> json) deSerializer, {String token = ""}) async {
    http.Response res = await http.get(
        Uri.parse(baseUrl + uri),
        headers: {
          "Authorization" : "Bearer $token",
          "Content-Type" : "application/json"
        }
    );
    if(HttpStatus.isSuccess(res.statusCode)) {
      return deSerializer(jsonDecode(res.body));
    } else {
      throw Exception("Error: ${res.statusCode} : ${res.body} ${res.request}");
    }
  }
}
