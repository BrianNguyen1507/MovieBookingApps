import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class LogOutServices {
  static Future<dynamic> logout() async {
    Preferences pref = Preferences();
    String? token = await pref.getTokenUsers();

    try {
      const url = 'http://${ipAddress}:8083/cinema/logout';
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
