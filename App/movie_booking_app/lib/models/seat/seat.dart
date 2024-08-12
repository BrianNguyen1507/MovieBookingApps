class Seat {
  int id;
  String timeStart;
  List<dynamic> seats;

  Seat({
    required this.id,
    required this.timeStart,
    required this.seats,
  });

  factory Seat.fromJson(Map<String, dynamic> jsonData) {
    return Seat(
      id: jsonData['id'],
      timeStart: jsonData['timeStart'],
      seats: dynamicToSeatStatus(jsonData['seat']),
    );
  }
}

List<List<int>> dynamicToSeatStatus(List<dynamic> list) {
  List<List<int>> seats = list.map((row) {
    return (row as List<dynamic>).map((seatStatus) {
      return seatStatus as int;
    }).toList();
  }).toList();
  return seats;
}
