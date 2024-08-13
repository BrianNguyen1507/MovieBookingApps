import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/constant/app_config.dart';
import 'dart:convert';

import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/response/error_code.dart';
import 'package:movie_booking_app/response/response.dart';
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

      final apiresponse =
          ResponseFunction<dynamic>.fromJson(responseData, (data) {
        final dynamic getResult = data as dynamic;
        return getResult;
      }, context);
      if (!apiresponse.isSuccess) {
        debugPrint('Error signup message: ${responseData['message']}');
        ValidInput().showMessage(
            context,
            ResponseCode.getMessage(apiresponse.code, context)!.message,
            AppColors.errorColor);
        return false;
      }

      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    }
    return false;
  }
}

class OTPService {
  static Future<dynamic> otpService(String email, String otp, String method) async {
    try {
      final getURL = dotenv.env['GET_OTP_ACTIVE']!;
      final apiUrl = getURL;
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'otp': otp,'method':method}),
      );
      print(method);
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
