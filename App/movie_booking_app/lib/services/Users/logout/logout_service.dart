import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';

class LogOutServices {
  static Future<dynamic> logout(context) async {
    Preferences pref = Preferences();
    String? token = await pref.getTokenUsers();
    try {
      final getURL = dotenv.env['LOG_OUT']!;
      final url = getURL;
      final logoutBody = json.encode({'token': token});

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: logoutBody,
      );

      if (response.statusCode != 200) {
        debugPrint('Log out Service Code: ${response.statusCode}');
      }
      final responseData = json.decode(response.body);

      if (responseData['code'] != 1000) {
        await pref.clear();
        return;
      }
      return responseData['message'];
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
  }
}
