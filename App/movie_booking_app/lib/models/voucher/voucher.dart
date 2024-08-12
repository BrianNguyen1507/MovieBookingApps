class Voucher {
  final int id;
  final String title;
  final String content;
  final int typeDiscount;
  final double minLimit;
  final double discount;
  final int quantity;
  final String expired;
  final bool allowed;

  Voucher({
    required this.id,
    required this.title,
    required this.content,
    required this.typeDiscount,
    required this.minLimit,
    required this.discount,
    required this.quantity,
    required this.expired,
    required this.allowed,
  });

  factory Voucher.fromJson(Map<String, dynamic> jsonData) {
    return Voucher(
      id: jsonData['id'],
      title: jsonData['title'],
      content: jsonData['content'],
      typeDiscount: jsonData['typeDiscount'],
      minLimit: jsonData['minLimit'],
      discount: jsonData['discount'],
      quantity: jsonData['quantity'],
      expired: jsonData['expired'],
      allowed: jsonData['allow'] ?? false,
    );
  }
}
