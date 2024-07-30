import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/models/response/response.dart';

class MovieList {
  static Future<List<Movie>?> getListReleased(BuildContext context) async {
    final getURL = dotenv.env['GET_LIST_RELEASE']!;
    final url = getURL;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        debugPrint('ListMovie Error code: ${response.statusCode}');
        return null;
      }
      final responseData = json.decode(utf8.decode(response.body.codeUnits));
      final apiResponse = Response<List<Movie>>.fromJson(
        responseData,
        (json) {
          final List<dynamic> movieList = json as List<dynamic>;
          return movieList.map((item) => Movie.fromJson(item)).toList();
        },
      );
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        debugPrint('Error get list release message: ${apiResponse.message}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching released movies: $e');
      return null;
    }
  }

  static Future<List<Movie>?> getListFutured(context) async {
    final getURL = dotenv.env['GET_LIST_FUTURE']!;
    final urlApi = getURL;
    final response = await http.get(
      Uri.parse(urlApi),
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      debugPrint('Error get list future code: ${response.statusCode}');
    }

    final responsefetch = json.decode(utf8.decode(response.body.codeUnits));
    final apiResponse = Response<List<Movie>>.fromJson(responsefetch, (json) {
      final List<dynamic> result = json as List<dynamic>;
      return result.map((item) => Movie.fromJson(item)).toList();
    });
    if (apiResponse.isSuccess) {
      return apiResponse.result;
    } else {
      debugPrint('Error get list future message: ${apiResponse.message}');
      return null;
    }
  }

  static Future<List<Movie>?> getAllListMovie(context) async {
    final getUri = dotenv.env['GET_ALL_LIST_MOVIE']!;
    final response = await http.get(
      Uri.parse(getUri),
      headers: {
        'Content-type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      debugPrint('Error get all movies with code: ${response.statusCode}');
    }
    final data = jsonDecode(utf8.decode(response.body.codeUnits));
    final apiResponse = Response<List<Movie>>.fromJson(data, (json) {
      final List<dynamic> result = json as List<dynamic>;
      return result.map((item) => Movie.fromJson(item)).toList();
    });
    if (apiResponse.isSuccess) {
      return apiResponse.result;
    } else {
      debugPrint(
          'Error get list getAllListMovie message: ${apiResponse.message}');
      return null;
    }
  }
}
