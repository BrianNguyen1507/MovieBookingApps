import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/user/user.dart';

class SignUpService {
  static Future<dynamic> signup(User user) async {
    try {
      const apiUrl = "http://$ipAddress:8083/cinema/register";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toJson()),
      );
      final responseData = json.decode(response.body);
      if (responseData['code'] != 1000) {
        return responseData['message'];
      }
      if (responseData['code'] == 1000) {
        return true;
      }
    } catch (error) {
      print('Exception: $error');
    }
  }
}

class OTPService {
  static Future<dynamic> otpService(String email, String otp) async {
    try {
      const apiUrl = "http://$ipAddress:8083/cinema/activeAccount";
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'otp': otp}),
      );
      final responseData = json.decode(response.body);

      if (responseData['code'] != 1000) {
        return responseData['message'];
      }
      if (responseData['code'] == 1000) {
        return true;
      }
    } catch (error) {
      print('Exception: $error');
      return 'Exception: $error';
    }
  }
}
