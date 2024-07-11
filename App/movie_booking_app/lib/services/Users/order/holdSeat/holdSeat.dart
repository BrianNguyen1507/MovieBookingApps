import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class HoldSeatService {
  static Future<bool> holdSeat(int scheduleId, Set<String> seats) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();
      String seatString = ConverterUnit.convertSetToString(seats);
      
      final getURL = dotenv.env['HOLD_SEAT']!;
      final url = getURL
          .replaceAll('{scheduleId}', scheduleId.toString())
          .replaceAll('{seatString}', seatString);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['code'] != 1000) {
          throw Exception('Invalid: ${result['message']}');
        }
        print('hold thanh cong');
        return true;
      } else if (response.statusCode == 400) {
        print('Error code 400:${result['result']} ');
        return false;
      } else {
        throw Exception(
            'Error: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Cannot fetch hold seat: $e');
    }
  }
}
