import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class RefreshToken {
  static Future<dynamic> refreshToken() async {
    Preferences pref = Preferences();
    String? expriredToken = await pref.getTokenUsers();
    try {
      await dotenv.load();
      final getURL = dotenv.env['REFRESH_TOKEN']!;
      final url = getURL;
      final refreshBody = json.encode({'token': expriredToken});
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: refreshBody,
      );

      final responseData = json.decode(response.body);
      if (responseData['code'] != 1000) {
        return;
      }
      dynamic newToken = responseData['result']['token'];
      pref.saveTokenKey(newToken);
      print('new token:$newToken');
    } catch (e) {
      return 'Error: $e';
    }
  }
}
