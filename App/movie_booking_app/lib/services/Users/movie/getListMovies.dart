import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/category/categories.dart';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/movie/movie.dart';

class MovieList {
  static Future<List<Movie>> getListReleased() async {
    await dotenv.load();
    final getURL = dotenv.env['GET_LIST_RELEASE']!;
    final url = getURL;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['code'] != 1000) {
          throw Exception(responseData['message']);
        }
        final List<Movie> movies =
            List<Movie>.from(responseData['result'].map((movieData) {
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
            isRelease: movieData['release'],
          );
        }));

        return movies;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch data Released $error');
    }
  }

  static Future<List<Movie>> getListFutured() async {
    await dotenv.load();
    final getURL = dotenv.env['GET_LIST_FUTURE']!;
    final urlApi = getURL;
    final response = await http.get(
      Uri.parse(urlApi),
      headers: {'Content-type': 'application/json'},
    );
    try {
      final responsefetch = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responsefetch['code'] != 1000) {
          return responsefetch['message'];
        }
        final List<Movie> movies = List<Movie>.from(
          responsefetch['result'].map(
            (movieData) {
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
                isRelease: movieData['release'],
              );
            },
          ),
        );

        return movies;
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch data Futured $error');
    }
  }
}
