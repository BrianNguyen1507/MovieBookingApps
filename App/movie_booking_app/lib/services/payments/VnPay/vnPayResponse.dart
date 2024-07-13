class VnPayResponse {
  final String url;
  final String paymentCode;

  VnPayResponse({
    required this.url,
    required this.paymentCode,
  });

  factory VnPayResponse.fromJson(Map<String, dynamic> json) {
    return VnPayResponse(
      url: json['url'],
      paymentCode: json['paymentCode'],
    );
  }
}
