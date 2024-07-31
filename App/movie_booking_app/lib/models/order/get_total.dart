class GetTotal {
  double priceMovie;
  double? priceFood;
  double total;

  GetTotal({
    required this.priceMovie,
    required this.priceFood,
    required this.total,
  });

  factory GetTotal.fromJson(Map<String, dynamic> jsonTotal) {
    return GetTotal(
        priceMovie: jsonTotal['priceTicket'],
        priceFood: jsonTotal['priceFood'],
        total: jsonTotal['total']!);
  }
}
