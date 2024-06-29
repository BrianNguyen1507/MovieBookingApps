import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/seat/seat.dart';

class Seatservice {
  static Future<Seat> getMovieScheduleById(int scheduleId) async {
    final url =
        'http://$ipAddress:8083/cinema/getMovieScheduleById?id=${scheduleId}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] != 1000) {
          return result['message'];
        }
        final data = result['result'];
        return Seat(
          id: data['id'],
          timeStart: data['timeStart'],
          seats: data['seat'],
        );
      } else {
        throw Exception('error ${response.statusCode}');
      }
    } catch (err) {
      print(Exception('cant to fetch seat $err'));
      throw Exception('cant to fetch seat $err');
    }
  }
}
