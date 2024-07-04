import 'dart:ffi';

class OrderResponse {
  BigInt id;
  double sumTotal;
  DateTime? date;
  String paymentMethod;
  String paymentCode;
  String poster;
  String title;
  String status;
  int duration;
  String language;
  String classify;
  String releaseDate;

  OrderResponse(
      {required this.id,
      required this.sumTotal,
      required this.date,
      required this.paymentMethod,
      required this.title,
      required this.poster,
      required this.status,
        required this.duration,
        required this.paymentCode,
        required this.language,
        required this.classify,
        required this.releaseDate,
      });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
        id: BigInt.from(json['id']),
        sumTotal: (json['sumTotal'] as num).toDouble(),
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        paymentMethod: json['paymentMethod'],
        poster: json['film'] == null ? "" : json['film']['poster'],
        title: json['film'] == null ? "" : json['film']['title'],
        duration: json['film'] == null ? 0 : (json['film']['duration'] as num).toInt(),
        status: json['status'],
        paymentCode: json['paymentCode'],
      classify: "",
      language: "",
      releaseDate: "",
    );
  }
}
