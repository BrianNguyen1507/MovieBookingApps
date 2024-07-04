class Payment {
  final String id;
  final String title;
  final String description;
  final String method;
  final String image;
  Payment({
    required this.id,
    required this.title,
    required this.description,
    required this.method,
    required this.image,
  });
  static List<Payment> payments = [
    Payment(
      id: '1',
      title: 'ZALOPAY',
      description: 'Payment via ZaloPay',
      method: 'ZALO',
      image: 'assets/images/ZaloPay-vuong.png',
    ),
    Payment(
      id: '2',
      title: 'MOMO',
      description: 'Payment via Momo',
      method: 'MOMO',
      image: 'assets/images/ZaloPay-vuong.png',
    ),
    Payment(
      id: '3',
      title: 'VNPAY',
      description: 'Payment via Vnpay',
      method: 'VNPAY',
      image: 'assets/images/ZaloPay-vuong.png',
    ),
  ];
}
