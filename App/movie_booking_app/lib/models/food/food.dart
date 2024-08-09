class Food {
  final int id;
  final String name;
  final double price;
  final String image;
  final int quantity;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'].toInt(),
    );
  }
}
