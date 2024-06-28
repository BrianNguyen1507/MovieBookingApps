import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/schedule/schedule.dart';

class ScheduleService {
  static Future<Schedule?> getAllSchedule(
      String date, int theaterId, int movieId) async {
    final url =
        'http://${ipAddress}:8083/cinema/getAllScheduleMobile?filmId=$movieId&theaterId=$theaterId&date=$date';

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
