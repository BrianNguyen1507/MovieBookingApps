import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/constant/app_config.dart';
import 'dart:convert';

import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';

class SignUpService {
  static Future<bool> signup(context, User user) async {
    try {
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
      if (response.statusCode != 200) {
        debugPrint('Error signup code: ${response.statusCode}');
        ValidInput().showMessage(
            context, responseData['message'], AppColors.errorColor);
        return false;
      }
      if (responseData['code'] != 1000) {
        debugPrint('Error signup message: ${responseData['message']}');
        ValidInput().showMessage(
            context, responseData['message'], AppColors.errorColor);
        return false;
      }

      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}

class OTPService {
  static Future<dynamic> otpService(String email, String otp) async {
    try {
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
        return responseData['message'];
      }
      if (responseData['code'] == 1000) {
        return true;
      }
    } catch (error) {
      return 'Exception: $error';
    }
  }
}
