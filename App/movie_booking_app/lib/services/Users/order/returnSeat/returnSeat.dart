import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class ReturnSeatService {
  static Future<bool> returnSeat(int scheduleId, Set<String> seats) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();
      String seatString = ConverterUnit.convertSetToString(seats);
      print(seatString);
      final url =
          'http://$ipAddress:8083/cinema/returnSeat?scheduleId=$scheduleId&seat=$seatString';
      final response = await http.post(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] != 1000) {
          throw Exception('Invalid: ${result['message']}');
        }
        print('return thanh cong');

        return true;
      } else {
        throw Exception('error with status code ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant return seat: $err');
    }
  }
}
