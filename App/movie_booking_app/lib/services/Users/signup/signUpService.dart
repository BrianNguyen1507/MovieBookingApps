import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movie_booking_app/models/user/user.dart';

class SignUpService {
  static Future<dynamic> signup(User user) async {
    try {
      await dotenv.load();
      final getURL = dotenv.env['SIGN_UP']!;
      final apiUrl = getURL;
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
      await dotenv.load();
      final getURL = dotenv.env['GET_OTP_ACTIVE']!;
      final apiUrl = getURL;
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'otp': otp}),
      );
      final responseData = json.decode(response.body);

      if (responseData['code'] != 1000) {
        print(otp);
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
