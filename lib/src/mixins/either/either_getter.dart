import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/http_status.dart';
import '../../errors/min_rest_error.dart';

mixin MinRestGetterErrorOr {
  String get baseUrl;

  ///Get a [M] object or [MinRestError] from the [uri] endpoint.
  ///[uri] is resource path after the base url.
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  Future<Either<MinRestError, M>> getErrorOr<M>(String uri, M Function(Map<String, dynamic> json) deSerializer, {String token = ""}) async {
    // try {
      http.Response res = await http.get(
          Uri.parse(baseUrl + uri),
          headers: {
            "Authorization" : "Bearer $token",
            "Content-Type" : "application/json"
          }
      );
      if(HttpStatus.isSuccess(res.statusCode)) {
        return right(deSerializer(jsonDecode(res.body)));
      } else {
        return left(MinRestError(res.statusCode, res.body, res.request?.url.toString()));
      }
    // } catch (e) {
    //   print("Fucking catch ran");
    //   print(e);
    //   return left(MinRestError(0, "Error Loading Data", e.toString()));
    // }
  }
}


mixin MinRestGetterErrorOrListOf {
  String get baseUrl;

  ///Get a list of [M] object or [MinRestError] from the [uri] endpoint.
  ///[uri] is resource path after the base url.
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  Future<Either<MinRestError, List<M>>> getErrorOrListOf<M>(String uri, M Function(Map<String, dynamic> json) deSerializer, {String token = ""}) async {
    // try {
      http.Response res = await http.get(
          Uri.parse(baseUrl + uri),
          headers: {
            "Authorization" : "Bearer $token",
            "Content-Type" : "application/json"
          }
      );
      if(HttpStatus.isSuccess(res.statusCode)) {
        try{
          return right((jsonDecode(res.body) as List).map((e) => deSerializer(e)).toList());
        } catch(e) {
          return left(MinRestError(res.statusCode, res.body, res.request?.url.toString()));
        }
      } else {
        return left(MinRestError(res.statusCode, res.body, res.request?.url.toString()));
      }
    // } catch (e) {
    //   return left(MinRestError(0, "Error Loading Data", e.toString()));
    // }
  }
}