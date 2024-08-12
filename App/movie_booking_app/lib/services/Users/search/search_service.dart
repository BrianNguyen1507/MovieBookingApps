import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';

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
      dynamic result = json.decode(utf8.decode(response.body.codeUnits));
      if (response.statusCode != 200) {
        debugPrint('Error cant search service code:${response.statusCode}');
      }

      final apiResponse = ResponseFunction<List<Movie>>.fromJson(result, (data) {
        final List<dynamic> getMovie = data as List<dynamic>;
        return getMovie.map(((item) => Movie.fromJson(item))).toList();
      }, context);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        ShowMessage.unExpectedError(context);
        debugPrint('Error cant search service message:${apiResponse.message}');
      }
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
