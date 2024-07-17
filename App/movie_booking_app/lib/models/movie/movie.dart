import 'package:movie_booking_app/models/category/categories.dart';

class Movie {
  final int id;
  final String title;
  final String classify;
  final List<Categories> categories;
  final String poster;
  final DateTime? releaseDate;
  final bool isRelease;
  final String? trailer;
  Movie(
      {required this.isRelease,
      required this.id,
      required this.title,
      required this.classify,
      required this.categories,
      required this.poster,
      required this.trailer,
      this.releaseDate});
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      classify: json['classify'],
      categories: json['categories'],
      poster: json['poster'],
      trailer: json['trailer'],
      isRelease: json['release'],
    );
  }
}
