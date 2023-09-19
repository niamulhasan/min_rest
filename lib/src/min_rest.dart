import 'package:minimal_rest/src/mixins/either/either_deleter.dart';
import 'package:minimal_rest/src/mixins/either/either_getter.dart';
import 'package:minimal_rest/src/mixins/either/either_multipart_poster.dart';
import 'package:minimal_rest/src/mixins/either/either_patcher.dart';
import 'package:minimal_rest/src/mixins/either/either_poster.dart';
import 'package:minimal_rest/src/mixins/exception_throwers/poster.dart';

import 'mixins/exception_throwers/getter.dart';

class MinRest
    with
        MinRestGetter,
        MinRestGetterErrorOr,
        MinRestGetterErrorOrListOf,
        MinRestPoster,
        MinRestPosterErrorOr,
        MinRestMultipartPosterErrorOr,
        MinRestDeleterErrorOr,
        MinRestPatcherErrorOr {
  String _baseUrl;

  @override
  String get baseUrl => _baseUrl;

  //Singleton Setup for MinRest
  static MinRest? _instance;

  ///First call [MinRest.init] to initialize the singleton instance of [MinRest]
  MinRest.init(this._baseUrl) {
    _instance = this;
  }

  ///Use [MinRest()] to access all the methods of [MinRest]
  factory MinRest() {
    if (_instance == null) {
      throw Exception("You must call MinRest.init() before using MinRest");
    }
    return _instance!;
  }
}
