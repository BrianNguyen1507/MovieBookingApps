import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class ChangePasswordService {
  static Future<Account> changePassword(
      String password, String newPassword, context) async {
    final getURL = dotenv.env['CHANGE_PASSWORD']!;
    final url = getURL;
    final bodyRequest = jsonEncode({
      'password': password,
      'newPassword': newPassword,
    });
    Preferences preferences = Preferences();
    dynamic token = await preferences.getTokenUsers();
    try {
      final response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: bodyRequest);
      if (response.statusCode != 200) {
        debugPrint('Error changepass: ${response.statusCode}');
      }
      final responseData =
          jsonDecode(utf8.decode(response.body.runes.toList()));
      if (responseData['code'] != 1000) {
        debugPrint('Error code: ${responseData['message']}');
      }
      final result = responseData['result'];
      Preferences().setAvatar(result['avatar']);
      Preferences().setUserName(result['fullName']);
      return Account.fromJson(result);
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    //null
    return Account(
      email: '',
      avatar: '',
      fullName: '',
      phoneNumber: '',
      gender: '',
      dayOfBirth: '',
    );
  }
}
