class Schedule {
  final String date;
  final List<ScheduleByHour> scheduleByHour;
  final Film? film;

  Schedule({
    required this.date,
    required this.scheduleByHour,
    this.film,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      date: json['date'],
      scheduleByHour: (json['scheduleByHour'] as List)
          .map((item) => ScheduleByHour.fromJson(item))
          .toList(),
      film: json.containsKey('film') ? Film.fromJson(json['film']) : null,
    );
  }
}

class ScheduleByHour {
  final int id;
  final int roomNumber;
  final String times;

  ScheduleByHour({
    required this.id,
    required this.roomNumber,
    required this.times,
  });

  factory ScheduleByHour.fromJson(Map<String, dynamic> json) {
    return ScheduleByHour(
      id: json['id'],
      roomNumber: json['roomNumber'],
      times: json['times'],
    );
  }
}

class Film {
  final int id;
  final String title;
  final DateTime releaseDate;

  Film({
    required this.id,
    required this.title,
    required this.releaseDate,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      releaseDate: DateTime.parse(json['releaseDate']),
    );
  }
}
