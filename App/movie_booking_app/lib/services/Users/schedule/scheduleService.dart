import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/schedule/schedule.dart';

class ScheduleService {
  static Future<Schedule?> getAllSchedule(
      String date, int theaterId, int movieId) async {
    await dotenv.load();
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

      if (result['code'] != 1000) {
        throw Exception(result['message'] ?? 'Unknown error');
      }

      final scheduleData = result['result'];

      if (scheduleData == null) {
        return null;
      }

      return Schedule.fromJson(scheduleData);
    } catch (e) {
      return null;
    }
  }
}
