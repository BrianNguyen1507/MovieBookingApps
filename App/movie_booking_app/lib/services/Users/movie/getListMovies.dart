import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/movie/movie.dart';

class MovieList {
  static Future<List<Movie>?> getListReleased(context) async {
    final getURL = dotenv.env['GET_LIST_RELEASE']!;
    final url = getURL;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      debugPrint('ListMovie Error code: ${response.statusCode}');
    }
    final responseData = json.decode(response.body);
    if (responseData['code'] != 1000) {
      debugPrint('Error get list release message: ${responseData['message']}');
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
        trailer: movieData['trailer'],
      );
    }));

    return movies;
  }

  static Future<List<Movie>?> getListFutured(context) async {
    final getURL = dotenv.env['GET_LIST_FUTURE']!;
    final urlApi = getURL;
    final response = await http.get(
      Uri.parse(urlApi),
      headers: {'Content-type': 'application/json'},
    );

    final responsefetch = json.decode(response.body);
    if (response.statusCode != 200) {
      debugPrint('Error get list future code: ${response.statusCode}');
    }
    if (responsefetch['code'] != 1000) {
      debugPrint('Error get list future message: ${responsefetch['message']}');
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
            trailer: movieData['trailer'],
          );
        },
      ),
    );

    return movies;
  }

  static Future<List<Movie>?> getAllListMovie(context) async {
    final getUri = dotenv.env['GET_ALL_LIST_MOVIE']!;
    final response = await http.get(
      Uri.parse(getUri),
      headers: {
        'Content-type': 'application/json',
      },
    );
    final data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      debugPrint('Error get all movies with code: ${response.statusCode}');
    }
    if (data['code'] != 1000) {
      debugPrint('error with message: ${data['message']}');
    }
    final List<Movie> movies = List<Movie>.from(data['result'].map((movieData) {
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
        trailer: movieData['trailer'],
      );
    }));

    return movies;
  }
}
