import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/http_status.dart';
import '../../errors/min_rest_error.dart';

mixin MinRestMultipartPosterErrorOr {
  String get baseUrl;

  ///Post a [M] object to the [uri] endpoint or get [MinRestError] if there is an error.
  ///If there is no body to send, pass an [bool] as [M].
  /// [filePaths] is [List<Map<String, String>]. put only one key value pair in each [Map] item of the [List]
  ///If [bool] is passed as [M], [data] and [deSerializer] will be ignored.
  ///[uri] is resource path after the base url.
  ///Pass your [dataModel.toJson] as [data].
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  //TODO: Create exception thrower version of this
  Future<Either<MinRestError, M>> postMultipartErrorOr<M>(
      String uri, List<Map<String, String>> filePaths,
      {Map<String, String>? data,
      M Function(Map<String, dynamic> json)? deSerializer,
      String token = ""}) async {
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(baseUrl + uri));

    // for (String filePath in filePaths) {
    //   request.files.add(await http.MultipartFile.fromPath('image', filePath));
    // }
    for( Map<String, String> imageItem in filePaths){
      request.files.add(await http.MultipartFile.fromPath(imageItem.keys.first, imageItem.values.first));
    }

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Content-type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    });

    if (data != null) {
      request.fields.addAll(data);
    }

    http.StreamedResponse response = await request.send();

    if (HttpStatus.isSuccess(response.statusCode)) {
      if (deSerializer != null) {
        return right(
            deSerializer(jsonDecode(await response.stream.bytesToString())));
      }
      return right(true as M);
    }
    return left(MinRestError(
        response.statusCode,
        await response.stream.bytesToString(),
        response.request?.url.toString()));
  }
}
