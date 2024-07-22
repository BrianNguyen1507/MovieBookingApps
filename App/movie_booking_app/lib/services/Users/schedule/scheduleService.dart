import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/schedule/schedule.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';

class ScheduleService {
  static Future<Schedule?> getAllSchedule(
      context, String date, int theaterId, int movieId) async {
    final getURL = dotenv.env['GET_ALL_SCHEDULE_MOBILE']!;
    final url = getURL
        .replaceAll('{filmInput}', movieId.toString())
        .replaceAll('{theaterInput}', theaterId.toString())
        .replaceAll('{dateInput}', date);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );

      final result = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint(
            'Error get all schedule service code: ${response.statusCode}');
        return null;
      }

      if (result['code'] != 1000) {
        ShowMessage.unExpectedError(context);
        debugPrint(
            'Error get all schedule service message: ${result['message']}');
      }
      dynamic scheduleData;
      if (result['result'] != null) {
        scheduleData = result['result'];
      } else {
        return null;
      }

      return Schedule.fromJson(scheduleData);
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
