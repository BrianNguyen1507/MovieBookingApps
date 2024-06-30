class Food {
  final int id;
  final String name;
  final double price;
  final String image;

  Food({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        image: json['image']);
  }
}
