class Film {
  final int id;
  final String title;
  final int duration;
  final String releaseDate;
  final String poster;

  Film({
    required this.id,
    required this.title,
    required this.duration,
    required this.releaseDate,
    required this.poster,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      releaseDate: json['releaseDate'],
      poster: json['poster'],
    );
  }
}

class MovieSchedule {
  final int id;
  final String date;
  final String timeStart;
  final String timeEnd;
  final Film film;

  MovieSchedule({
    required this.id,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.film,
  });

  factory MovieSchedule.fromJson(Map<String, dynamic> json) {
    return MovieSchedule(
      id: json['id'],
      date: json['date'],
      timeStart: json['timeStart'],
      timeEnd: json['timeEnd'],
      film: Film.fromJson(json['film']),
    );
  }
}

class Result {
  final int id;
  final String seat;
  final String date;
  final bool allowUse;
  final MovieSchedule movieSchedule;
  final String theaterName;
  final int roomNumber;
  final String address;
  Result(
      {required this.id,
      required this.seat,
      required this.date,
      required this.allowUse,
      required this.movieSchedule,
      required this.theaterName,
      required this.roomNumber,
      required this.address});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      seat: json['seat'],
      date: json['date'],
      allowUse: json['allowUse'],
      movieSchedule: MovieSchedule.fromJson(json['movieSchedule']),
      theaterName: json['theaterName'],
      roomNumber: json['roomNumber'],
      address: json['address'],
    );
  }
}
