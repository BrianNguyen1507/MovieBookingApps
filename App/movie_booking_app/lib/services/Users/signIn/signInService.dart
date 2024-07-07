import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class SignInService {
  static Future<dynamic> signin(String email, String password) async {
    try {
      await dotenv.load();
      final getURL = dotenv.env['SIGN_IN']!;
      final apiUrl = getURL;
      final signInData = json.encode({'email': email, 'password': password});
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: signInData,
      );
      final responseData = json.decode(response.body);
      if (responseData['code'] != 1000) {
        return responseData['message'];
      }
      if (responseData['code'] == 1000) {
        dynamic token = responseData['result']['token'];
        dynamic auth = responseData['result']['authenticated'].toString();
        dynamic endcodeName = responseData['result']['name'];
        dynamic name = utf8.decode(endcodeName.codeUnits);
        dynamic avatar = responseData['result']['avatar'] ?? "";
        await Preferences().saveAuthenticated(auth, token);
        await Preferences().saveSignInInfo(email, password, name, avatar);
        Preferences pref = Preferences();
        dynamic getToken = await pref.getTokenUsers();
        print('auth: $getToken');
        return true;
      }
    } catch (error) {
      print('Exception: $error');
    }
  }
}
