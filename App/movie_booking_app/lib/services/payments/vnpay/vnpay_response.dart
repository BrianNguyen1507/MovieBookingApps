class VnPayResponse {
  final String url;

  VnPayResponse({
    required this.url,
  });

  factory VnPayResponse.fromJson(Map<String, dynamic> json) {
    return VnPayResponse(
      url: json['url'],
    );
  }
}
