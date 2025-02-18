import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../core/http_status.dart';
import '../../errors/min_rest_error.dart';

mixin MinRestMultipartPosterErrorOr {
  String get baseUrl;

  ///Post a [M] object to the [uri] endpoint or get [MinRestError] if there is an error.
  ///If there is no body to send, pass an [bool] as [M].
  ///If [bool] is passed as [M], [data] and [deSerializer] will be ignored.
  ///[uri] is resource path after the base url.
  ///Pass your [dataModel.toJson] as [data].
  ///Pass your [DataModel.fromJson] function as [deSerializer].
  ///[token] is the bearer token.
  //TODO: Create exception thrower version of this
  Future<Either<E, M>> postMultipartErrorOr<E, M>(
    String uri,
    List<Map<String, String>> fileKeysAndPaths,
    {
    Map<String, String>? data,
    M Function(Map<String, dynamic> json)? deSerializer,
    required E Function(Map<String, dynamic> json) errorDeserializer,
    String? token,
    bool logResponse = true,
    bool doUriIncludeBaseUrl = false,
    bool shouldThrowException = false,
  }) async {
    // try {
      String fullUri = doUriIncludeBaseUrl ? uri : baseUrl + uri;
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(fullUri));

      print("hhhhooo");
      for (Map<String, String> fileKeyAndPath in fileKeysAndPaths) {
        print("Attaching file: key: ${fileKeyAndPath.keys.first}, path: ${fileKeyAndPath.values.first}");
        request.files.add(
          await http.MultipartFile.fromPath(
            fileKeyAndPath.keys.first,
            fileKeyAndPath.values.first,
            contentType: _contentTypeFromPath(fileKeyAndPath.values.first),
          ),
        );
      }

      Map<String, String> header = {
        // "Content-type": "application/json",
        "X-Requested-With": "XMLHttpRequest"
      };

      if (token != null) {
        header["Authorization"] = "Bearer $token";
      }

      request.headers.addAll(header);

      if (data != null) {
        request.fields.addAll(data);
      }

      http.StreamedResponse response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (logResponse) {
        print('MinRest: MultipartPost@ ${baseUrl + uri}');
        print("body $data");
        print('File Keys and Paths: $fileKeysAndPaths');
        print('Response: (${response.statusCode}) $responseBody');
      }

      if (HttpStatus.isSuccess(response.statusCode)) {
        if (deSerializer != null) {
          return right(
              deSerializer(jsonDecode(responseBody)));
        }
        return right(true as M);
      }
      // return left(MinRestError(
      //     response.statusCode,
      //     await response.stream.bytesToString(),
      //     response.request?.url.toString()));
      print('MinRest:${response.statusCode} (Server) Error@ ${baseUrl + uri}');
      print("request body: $data");
      print("response: $responseBody");
      print("response headers: ${response.headers}");
      if(responseBody.isEmpty){
        return left(errorDeserializer({
          'status_code': response.statusCode,
          'success': false,
          'message': "No response body",
        }));
      }
      return left(
          errorDeserializer(jsonDecode(responseBody)));
    // } catch (e) {
    //   if (shouldThrowException) {
    //     rethrow;
    //   } else {
    //     // return left(MinRestError(0, "Error Loading Data", e.toString()));
    //     print('MinRest: (Exception) Error@ ${baseUrl + uri}');
    //     print("body: ${e.toString()}");
    //     return left(errorDeserializer({
    //       'status_code': 500,
    //       'success': false,
    //       'message': e.toString(),
    //     }));
    //   }
    // }
  }


  MediaType? _contentTypeFromPath(String path) {
    final segments = path.split('.');
    if (segments.length < 2) {
      return MediaType('application', 'octet-stream');
    }
    final extension = segments.last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'webp':
        return MediaType('image', 'webp');
      case 'svg':
        return MediaType('image', 'svg+xml');
      case 'pdf':
        return MediaType('application', 'pdf');
      case 'doc':
        return MediaType('application', 'msword');
      case 'docx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.wordprocessingml.document');
      case 'xls':
        return MediaType('application', 'vnd.ms-excel');
      case 'xlsx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      case 'ppt':
        return MediaType('application', 'vnd.ms-powerpoint');
      case 'pptx':
        return MediaType('application',
            'vnd.openxmlformats-officedocument.presentationml.presentation');
      case 'txt':
        return MediaType('text', 'plain');
      case 'csv':
        return MediaType('text', 'csv');
      case 'json':
        return MediaType('application', 'json');
      case 'xml':
        return MediaType('application', 'xml');
      case 'zip':
        return MediaType('application', 'zip');
      case 'rar':
        return MediaType('application', 'x-rar-compressed');
      case 'tar':
        return MediaType('application', 'x-tar');
      case 'gz':
        return MediaType('application', 'x-gzip');
      case '7z':
        return MediaType('application', 'x-7z-compressed');
      case 'mp3':
        return MediaType('audio', 'mpeg');
      case 'wav':
        return MediaType('audio', 'wav');
      case 'ogg':
        return MediaType('audio', 'ogg');
      case 'flac':
        return MediaType('audio', 'flac');
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'mkv':
        return MediaType('video', 'x-matroska');
      default:
        return null;
    }
  }
}
