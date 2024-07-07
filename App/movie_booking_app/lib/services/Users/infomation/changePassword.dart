import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class ChangePasswordService {
  static Future<Account> changePassword(
      String password, String newPassword) async {
    await dotenv.load();
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
        print(response.statusCode);
      }
      final responseData =
          jsonDecode(utf8.decode(response.body.runes.toList()));
      if (responseData['code'] != 1000) {
        print(responseData['message']);
      }
      final result = responseData['result'];
      Preferences().setAvatar(result['avatar']);
      Preferences().setUserName(result['fullName']);

      return Account.fromJson(result);
    } catch (err) {
      throw Exception(err);
    }
  }
}
