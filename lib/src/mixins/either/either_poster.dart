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
  Future<Either<E, M>> postErrorOr<E, M>({
    required String uri,
    required Map<String, dynamic> data,
    required M Function(dynamic json) deSerializer,
    required E Function(Map<String, dynamic> json) errorDeserializer,
    String? token,
    bool logResponse = true,
    bool doUriIncludeBaseUrl = false,
    bool shouldThrowException = false,
  }) async {
    try {
      String fullUri = doUriIncludeBaseUrl ? uri : baseUrl + uri;
      http.Response res = await http.post(Uri.parse(fullUri),
          headers: token == null
              ? {"Content-Type": "application/json"}
              : {
                  "Authorization": "Bearer $token",
                  "Content-Type": "application/json"
                },
          body: jsonEncode(data));
      if(logResponse){
        print('MinRest: Post@ ${baseUrl + uri}');
        print("body $data");
        print('Response: ${res.body}');
      }
      if (HttpStatus.isSuccess(res.statusCode)) {
        return right(deSerializer(jsonDecode(res.body)));
      } else {
        return left(errorDeserializer(jsonDecode(res.body)));
      }
    } catch (e) {
      print("throwing");
      // return left(errorDeserializer(jsonDecode(e.toString())));
      if(shouldThrowException){
        rethrow;
      }else{
        try{
          return left(errorDeserializer(jsonDecode(e.toString())));
        }
        catch(e) {
          return left(errorDeserializer({
            'status_code': 500,
            'success': false,
            'message': e.toString(),
          }));
        }
      }
    }
  }
}
