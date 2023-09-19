import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/http_status.dart';
import '../../errors/min_rest_error.dart';

mixin MinRestPatcherErrorOr {
  String get baseUrl;

  ///Patch a [M] object to the [uri] endpoint or get [MinRestError] if there is an error.
  ///[uri] is resource path after the base url.
  ///Pass your [dataModel.toJson] as [data].
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  Future<Either<E, M>> patchErrorOr<E, M>({
    required String uri,
    required Map<String, dynamic> data,
    required M Function(Map<String, dynamic> json) deSerializer,
    required E Function(Map<String, dynamic> json) errorDeserializer,
    String token = "",
  }) async {
    try {
      http.Response res = await http.patch(Uri.parse(baseUrl + uri),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: jsonEncode(data));
      if (HttpStatus.isSuccess(res.statusCode)) {
        return right(deSerializer(jsonDecode(res.body)));
      } else {
        return left(errorDeserializer(jsonDecode(res.body)));
      }
    } catch (e) {
      return left(errorDeserializer(jsonDecode(e.toString())));
    }
  }
}
