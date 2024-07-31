import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/response/response.dart';
import 'package:movie_booking_app/models/theater/theater.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/show_message.dart';

class GetAllMovieTheater {
  static Future<List<Theater>?> getAllMovieTheater(context) async {
    final getURL = dotenv.env['GET_ALL_THEATER']!;
    final url = getURL;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode != 200) {
        debugPrint(
            'Error getAllMovieTheater service code: ${response.statusCode}');
      }
      final result = json.decode(response.body);
      final apiResponse = Response<List<Theater>>.fromJson(result, (data) {
        final List<dynamic> getTheater = data as List<dynamic>;
        return getTheater.map((item) => Theater.fromJson(item)).toList();
      });
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        ShowMessage.unExpectedError(context);
        debugPrint(
            'Error getAllMovieTheater service message: ${apiResponse.message}');
      }
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
