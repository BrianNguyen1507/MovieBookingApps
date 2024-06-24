import 'package:movie_booking_app/models/category/categories.dart';

class MovieDetail {
  final int id;
  final String title;
  final int duration;
  final String director;
  final String actor;
  final String trailer;
  final dynamic description;
  final String country;
  final String language;
  final double price;
  final String classify;
  final List<Categories> categories;
  final dynamic poster;
  final DateTime? releaseDate;
  final bool isRelease;

  MovieDetail({
    required this.id,
    required this.title,
    required this.classify,
    required this.categories,
    required this.releaseDate,
    required this.price,
    required this.actor,
    required this.director,
    required this.description,
    required this.country,
    required this.duration,
    required this.language,
    required this.poster,
    required this.trailer,
    required this.isRelease,
  });
  factory MovieDetail.fromJson(Map<dynamic, dynamic> json) {
    return MovieDetail(
        id: json['id'],
        title: json['title'],
        classify: json['classify'],
        categories: json['categories'],
        poster: json['poster'],
        actor: json['actor'],
        director: json['director'],
        country: json['country'],
        duration: json['duration'],
        price: json['basePrice'],
        description: json['description'],
        language: json['language'],
        releaseDate: json['releaseDate'],
        trailer: json['trailer'],
        isRelease: json['release']);
  }
}
