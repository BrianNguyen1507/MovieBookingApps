import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:movie_booking_app/models/category/categories.dart';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';

class MovieDetailService {
  static Future<MovieDetail?> deatailMovieService(context, int id) async {
    final getURL = dotenv.env['GET_MOVIE_BY_ID']!;
    final url = getURL + id.toString();

    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });

      if (response.statusCode != 200) {
        debugPrint('Error movie detail $id code: ${response.statusCode}');
      }
      final data = json.decode(utf8.decode(response.body.codeUnits));

      if (data['code'] != 1000) {
        debugPrint('Failed to fetch movie detail: ${data['message']}');
      }

      final detailData = data['result'];
      List<dynamic> categories = detailData['categories'];
      List<Categories> listCategory =
          categories.map((category) => Categories.fromJson(category)).toList();

      MovieDetail movieDetail = MovieDetail(
        id: detailData['id'],
        title: detailData['title'],
        classify: detailData['classify'],
        categories: listCategory,
        releaseDate: DateTime.parse(detailData['releaseDate']),
        price: detailData['basePrice'],
        actor: detailData['actor'],
        director: detailData['director'],
        description: detailData['description'],
        country: detailData['country'],
        duration: detailData['duration'],
        language: detailData['language'],
        poster: detailData['poster'],
        trailer: detailData['trailer'],
        isRelease: detailData['release'],
      );

      return movieDetail;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
