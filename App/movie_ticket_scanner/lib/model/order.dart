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
  final Film? film;

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
      film: json['film'] != null ? Film.fromJson(json['film']) : null,
    );
  }
}

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
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      quantity: json['quantity'],
    );
  }
}

class Result {
  final int id;
  final String? seat;
  final double sumtotal;
  final String date;
  final bool allowUse;
  final MovieSchedule? movieSchedule;
  final String? theaterName;
  final int roomNumber;
  final String? address;
  final List<Food>? foods;

  Result({
    required this.id,
    required this.seat,
    required this.sumtotal,
    required this.date,
    required this.allowUse,
    required this.movieSchedule,
    required this.theaterName,
    required this.roomNumber,
    required this.address,
    required this.foods,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      seat: json['seat'],
      sumtotal: (json['sumTotal'] as num).toDouble(),
      date: json['date'],
      allowUse: json['allowUse'],
      movieSchedule: json['movieSchedule'] != null
          ? MovieSchedule.fromJson(json['movieSchedule'])
          : null,
      theaterName: json['theaterName'],
      roomNumber: json['roomNumber'] ?? 0,
      address: json['address'],
      foods: json['foods'] != null
          ? (json['foods'] as List<dynamic>)
              .map((foodJson) => Food.fromJson(foodJson))
              .toList()
          : null,
    );
  }
}
