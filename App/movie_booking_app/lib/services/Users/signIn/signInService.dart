import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class SignInService {
  static Future<dynamic> signin(String email, String password) async {
    try {
      const apiUrl = "http://$ipAddress:8083/cinema/login";
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
        await Preferences().saveAuthenticated(auth, token);
        await Preferences().saveSignInInfo(email, password);
        print('auth: $auth- $token ');
        print('user: $email- $password ');
        return true;
      }
    } catch (error) {
      print('Exception: $error');
    }
  }
}
