enum HttpStatusType {
  /// 1xx: Informational - Request received, continuing process
  informational,
  /// 2xx: Success - The action was successfully received, understood, and accepted
  success,
  /// 3xx: Redirection - Further action must be taken in order to complete the request
  redirection,
  /// 4xx: Client Error - The request contains bad syntax or cannot be fulfilled
  clientError,
  /// 5xx: Server Error - The server failed to fulfill an apparently valid request
  serverError,
}

class HttpStatus {

  static bool isSuccess(int code) {
    return code >= 200 && code < 300;
  }

  static bool isRedirection(int code) {
    return code >= 300 && code < 400;
  }

  static bool isClientError(int code) {
    return code >= 400 && code < 500;
  }

  static bool isServerError(int code) {
    return code >= 500 && code < 600;
  }

  static HttpStatusType getType(int code) {
    if (code >= 100 && code < 200) {
      return HttpStatusType.informational;
    } else if (code >= 200 && code < 300) {
      return HttpStatusType.success;
    } else if (code >= 300 && code < 400) {
      return HttpStatusType.redirection;
    } else if (code >= 400 && code < 500) {
      return HttpStatusType.clientError;
    } else if (code >= 500 && code < 600) {
      return HttpStatusType.serverError;
    }
    return HttpStatusType.serverError;
  }

  //successful responses
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int nonAuthoritativeInformation = 203;
  static const int noContent = 204;


  //client error responses
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int paymentRequired = 402;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int notAcceptable = 406;
  static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int gone = 410;
  static const int lengthRequired = 411;
  static const int preconditionFailed = 412;
  static const int payloadTooLarge = 413;
  static const int uriTooLong = 414;
  static const int unsupportedMediaType = 415;
  static const int rangeNotSatisfiable = 416;
  static const int expectationFailed = 417;
  static const int imATeapot = 418;
  static const int misdirectedRequest = 421;
  static const int unprocessableEntity = 422;
  static const int locked = 423;
  static const int failedDependency = 424;
  static const int upgradeRequired = 426;
  static const int preconditionRequired = 428;
  static const int tooManyRequests = 429;
  static const int requestHeaderFieldsTooLarge = 431;
  static const int unavailableForLegalReasons = 451;

  //server error responses
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
  static const int httpVersionNotSupported = 505;
  static const int variantAlsoNegotiates = 506;
  static const int insufficientStorage = 507;
  static const int loopDetected = 508;
  static const int notExtended = 510;
  static const int networkAuthenticationRequired = 511;

}


