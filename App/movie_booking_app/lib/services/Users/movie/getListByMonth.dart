import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:movie_booking_app/models/movie/movie.dart';

class GetListByMonth {
  static Future<Map<int, List<Movie>>> getListByMonth() async {
    List<int> months = ConverterUnit.caculateMonth();
    Map<int, List<Movie>> moviesByMonth = {};
    try {
      for (int month in months) {
        final getURL = dotenv.env['GET_LIST_MONTH']!;
        final url = getURL;
        final response = await http.get(
          Uri.parse(url + month.toString()),
          headers: {
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['code'] != 1000) {
            throw Exception(result['message']);
          }
          final List<Movie> movies = List<Movie>.from(
            result['result'].map(
              (movieData) {
                List<dynamic> categories = movieData['categories'];
                List<Categories> listCategory = List<Categories>.from(
                    categories.map((category) => Categories(
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
          moviesByMonth[month] = movies;
        } else {
          throw Exception('Failed to fetch data: ${response.statusCode}');
        }
      }
      return moviesByMonth;
    } catch (err) {
      throw Exception(err);
    }
  }
}
