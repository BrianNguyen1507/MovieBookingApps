import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';

class SearchMovieService {
  static Future<List<Movie>?> findAllMovieByKeyWord(
      context, String keyword) async {
    try {
      final getURL = dotenv.env['SEARCH']!;
      final url = getURL + keyword;
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      dynamic result = json.decode(response.body);
      if (response.statusCode != 200) {
        debugPrint('Error cant search service code:${response.statusCode}');
      }
      if (result["code"] != 1000) {
        ShowMessage.unExpectedError(context);
        debugPrint('Error cant search service message:${result["message"]}');
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
          isRelease: movieData['release'],
          trailer: movieData['trailer'],
        );
      }));
      return movies;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
