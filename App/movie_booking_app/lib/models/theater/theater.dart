class Theater {
  final int id;
  final String name;
  final String address;

  Theater({
    required this.id,
    required this.name,
    required this.address,
  });
  factory Theater.fromJson(Map<String, dynamic> jsonData) {
    return Theater(
      id: jsonData['id'],
      name: jsonData['name'],
      address: jsonData['address'],
    );
  }
}
