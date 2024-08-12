import 'package:movie_booking_app/response/error_code.dart';

class ResponseFunction<T> {
  final int code;
  final String? message;
  final T? result;

  ResponseFunction({required this.code, this.message, this.result});

  factory ResponseFunction.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT, context) {
    final code = json['code'] as int;
    final result = json['result'];

    final responseCode = ResponseCode.getMessage(code, context);
    final message = responseCode?.message ?? json['message'];

    if (code == 1000) {
      return ResponseFunction<T>(
        code: code,
        result: fromJsonT(result),
      );
    } else {
      return ResponseFunction<T>(
        code: code,
        message: message,
      );
    }
  }

  bool get isSuccess => code == 1000;
}
