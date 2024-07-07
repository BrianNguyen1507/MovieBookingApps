import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class LogOutServices {
  static Future<dynamic> logout() async {
    Preferences pref = Preferences();
    String? token = await pref.getTokenUsers();

    try {
      final getURL = dotenv.env['LOG_OUT']!;
      final url = getURL;
      final logoutBody = json.encode({'token': token});

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: logoutBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['code'] == 1000) {
          print('LOG OUT THANH CONG');
          await pref.clear();
          return;
        } else {
          return responseData['message'];
        }
      } else {
        throw Exception('Failed to logout');
      }
    } catch (error) {
      return 'Error during logout';
    }
  }
}
