import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';

class GetListByMonth {
  static Future<Map<int, List<Movie>>?> getListByMonth(context) async {
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
        if (response.statusCode != 200) {
          debugPrint('List Movie By month error: ${response.statusCode}');
        }
        final result = json.decode(utf8.decode(response.body.codeUnits));
        if (result['code'] != 1000) {
          debugPrint('List Movie By month message: ${result['message']}');
        }

        final List<dynamic> getmovie = result['result'];
        final List<Movie> movies = getmovie.map((movm) {
          return Movie.fromJson(movm);
        }).toList();
        moviesByMonth[month] = movies;
      }
      return moviesByMonth;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
