import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/response/response.dart';
import 'package:movie_booking_app/models/seat/seat.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';

class Seatservice {
  static Future<Seat?> getMovieScheduleById(context, int scheduleId) async {
    final getURL = dotenv.env['GET_SEAT_BY_SCHEDULE_ID']!;
    final url = getURL + scheduleId.toString();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        debugPrint(
            'Error getMovieSchedule Service code: ${response.statusCode}');
      }
      final result = jsonDecode(response.body);
      final apiResponse = Response.fromJson(result, (data) {
        final dynamic seatData = data as dynamic;
        return Seat.fromJson(seatData);
      });
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        ShowMessage.unExpectedError(context);

        debugPrint(
            'Error getMovieSchedule Service message: ${apiResponse.message}');
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
