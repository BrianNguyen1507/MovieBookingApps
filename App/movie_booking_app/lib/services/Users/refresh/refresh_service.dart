import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/response/response.dart';

class RefreshToken {
  static Future<dynamic> refreshToken(context) async {
    Preferences pref = Preferences();
    String? expriredToken = await pref.getTokenUsers();
    try {
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
      if (response.statusCode != 200) {
        debugPrint('Error refresh token service code: ${response.statusCode}');
      }
      final apiResponse = ResponseFunction.fromJson(responseData, (data) {
        return data as dynamic;
      }, context);

      if (!apiResponse.isSuccess) {
        debugPrint(
            'Error refresh token service message: ${apiResponse.message}');
        return;
      }

      dynamic newToken = apiResponse.result['token'];
      pref.saveTokenKey(newToken);
      debugPrint('new token refreshed: $newToken');
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return;
  }
}
