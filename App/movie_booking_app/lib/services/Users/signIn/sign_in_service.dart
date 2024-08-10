import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'dart:convert';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/response/error_code.dart';
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';

class SignInService {
  static Future<dynamic> signin(context, String email, String password) async {
    try {
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
      if (response.statusCode != 200) {
        debugPrint('Error singin service code: ${response.statusCode}');
      }
      final apiResponse =
          ResponseFunction<dynamic>.fromJson(responseData, (data) {
        return data as dynamic;
      }, context);
      if (!apiResponse.isSuccess) {
        debugPrint('Error singin service message : ${responseData['message']}');
        ValidInput().showMessage(
            context,
            ResponseCode.getMessage(apiResponse.code, context)!.message,
            AppColors.errorColor);
        return false;
      }
      saveUserData(responseData, email, password);
      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}

void saveUserData(data, email, password) async {
  dynamic token = data['result']['token'];
  dynamic auth = data['result']['authenticated'].toString();
  dynamic endcodeName = data['result']['name'];
  dynamic name = utf8.decode(endcodeName.codeUnits);
  dynamic avatar = data['result']['avatar'] ?? "";
  await Preferences().saveAuthenticated(auth, token);
  await Preferences().saveSignInInfo(email, password, name, avatar);
  //
  Preferences pref = Preferences();
  dynamic getToken = await pref.getTokenUsers();
  debugPrint('success signin TOKEN: $getToken');
}
