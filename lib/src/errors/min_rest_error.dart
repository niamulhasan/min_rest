
class MinRestError {
  final String message;
  final int code;
  final String? details;

  MinRestError(this.code, this.message, [details]) : details = details ?? "";

  @override
  String toString() {
    return 'MinRestError{message: $message, code: $code, details: $details}';
  }
}