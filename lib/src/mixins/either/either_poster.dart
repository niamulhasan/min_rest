import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/http_status.dart';
import '../../errors/min_rest_error.dart';

mixin MinRestPosterErrorOr {
  String get baseUrl;

  ///Post a [M] object to the [uri] endpoint or get [MinRestError] if there is an error.
  ///[uri] is resource path after the base url.
  ///Pass your [dataModel.toJson] as [data].
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  Future<Either<MinRestError, M>> postErrorOr<M>(
      String uri,
      Map<String, dynamic> data,
      M Function(Map<String, dynamic> json) deSerializer,
      {String token = ""}) async {
   // try {
     http.Response res = await http.post(
         Uri.parse(baseUrl + uri),
         headers: {
           "Authorization": "Bearer $token",
           "Content-Type": "application/json"
         },
         body: jsonEncode(data)
     );
     if (HttpStatus.isSuccess(res.statusCode)) {
       return right(deSerializer(jsonDecode(res.body)));
     } else {
       return left(MinRestError(res.statusCode, res.body, res.request?.url.toString()));
     }
   // } catch (e) {
   //   return left(MinRestError(0, "Error Loading Data", e.toString()));
   // }
  }
}
