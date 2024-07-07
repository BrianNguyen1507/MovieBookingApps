import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class ReturnSeatService {
  static Future<bool> returnSeat(int scheduleId, Set<String> seats) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();
      String seatString = ConverterUnit.convertSetToString(seats);
      print(seatString);
      await dotenv.load();
      final getURL = dotenv.env['RETURN_SEAT']!;
      final url = getURL
          .replaceAll('{scheduleId}', scheduleId.toString())
          .replaceAll('{seatString}', seatString);
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
      } else if (response.statusCode == 400) {
        return false;
      } else {
        throw Exception('error with status code ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant return seat: $err');
    }
  }
}
