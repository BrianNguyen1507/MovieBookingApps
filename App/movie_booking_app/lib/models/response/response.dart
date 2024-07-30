class Response<T> {
  final int code;
  final String? message;
  final T? result;

  Response({required this.code, this.message, this.result});

  factory Response.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    final code = json['code'];
    if (code == 1000) {
      return Response<T>(
        code: code,
        result: fromJsonT(json['result']),
      );
    } else {
      return Response<T>(
        code: code,
        message: json['message'],
      );
    }
  }

  bool get isSuccess => code == 1000;
}
