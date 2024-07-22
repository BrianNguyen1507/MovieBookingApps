import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'dart:convert';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

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
        return false;
      }
      if (responseData['code'] != 1000) {
        debugPrint('Error singin service message : ${responseData['message']}');
        return false;
      }

      dynamic token = responseData['result']['token'];
      dynamic auth = responseData['result']['authenticated'].toString();
      dynamic endcodeName = responseData['result']['name'];
      dynamic name = utf8.decode(endcodeName.codeUnits);
      dynamic avatar = responseData['result']['avatar'] ?? "";
      await Preferences().saveAuthenticated(auth, token);
      await Preferences().saveSignInInfo(email, password, name, avatar);
      Preferences pref = Preferences();
      dynamic getToken = await pref.getTokenUsers();
      debugPrint('auth: $getToken');
      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}
