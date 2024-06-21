class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
    );
  }
}
