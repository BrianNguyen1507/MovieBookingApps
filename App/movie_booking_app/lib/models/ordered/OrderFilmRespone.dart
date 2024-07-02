class OrderResponse{
  BigInt id;
  double sumTotal;
  DateTime? date;
  String paymentMethod;
  String poster;
  String title;

  OrderResponse({ required this.id, required this.sumTotal, required this.date,required this.paymentMethod,required this.title, required this.poster});
  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id:  BigInt.from(json['id']),
      sumTotal: (json['sumTotal'] as num).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      paymentMethod: json['paymentMethod'],
      poster: json['film']==null?"":json['film']['poster'],
      title: json['film']==null?"":json['film']['title']
    );
  }
}