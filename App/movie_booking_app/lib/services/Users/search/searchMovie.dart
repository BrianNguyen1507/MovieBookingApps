import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:http/http.dart' as http;

class SearchMovieService {
  static Future<List<Movie>> findAllMovieByKeyWord(String keyword) async {
    try {
      var url = 'http://$ipAddress:8083/cinema/searchFilm?keyword=$keyword';
      final response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      dynamic result = json.decode(response.body);
      if (result["code"] != 1000) {
        return result["message"];
      }

      final List<Movie> movies =
          List<Movie>.from(result['result'].map((movieData) {
        List<dynamic> categories = movieData['categories'];
        List<Categories> listCategory =
            List<Categories>.from(categories.map((category) => Categories(
                  id: category['id'],
                  name: category['name'],
                )));

        return Movie(
          id: movieData['id'],
          title: movieData['title'],
          classify: movieData['classify'],
          categories: listCategory,
          poster: movieData['poster'],
        );
      }));
      return movies;
    } catch (error) {
      throw Exception(error);
    }
  }
}
