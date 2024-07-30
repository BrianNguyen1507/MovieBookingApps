import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:movie_booking_app/models/movie/movieDetail.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/response/response.dart';
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

      final apiResponse = Response<MovieDetail>.fromJson(data, (json) {
        final dynamic getResult = json;
        return MovieDetail.fromJson(getResult);
      });
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        debugPrint(
            'Error movie MovieDetail $id message: ${apiResponse.message}');
        return null;
      }
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
