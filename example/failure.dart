
class Failure {
  final int statusCode;
  final bool success;
  final String message;

  Failure(
    this.statusCode,
    this.success,
    this.message,
  );

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      json['status_code'],
      json['success'],
      (json['message'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'success': success,
      'message': message,
    };
  }
}
