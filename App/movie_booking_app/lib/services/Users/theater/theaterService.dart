import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/theater/theater.dart';

import 'package:http/http.dart' as http;

class GetAllMovieTheater {
  static Future<List<Theater>> getAllMovieTheater() async {
    const String url = 'http://${ipAddress}:8083/cinema/getAllMovieTheater';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['code'] != 1000) {
          return result['message'];
        }
        final List<Theater> theaters = List<Theater>.from(
          result['result'].map((item) => Theater(
                id: item['id'],
                name: item['name'],
                address: item['address'],
              )),
        );
        return theaters;
      } else {
        throw Exception('Failed to load theaters: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant fetching theater data $err');
    }
  }
}
