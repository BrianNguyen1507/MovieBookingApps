import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class MyInformation {
  static Future<Account> getMyInformation(context) async {
    Preferences pref = Preferences();
    dynamic token = await pref.getTokenUsers();
    final getURL = dotenv.env['GET_INFO']!;
    final url = getURL;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      final responseData =
          jsonDecode(utf8.decode(response.body.runes.toList()));
      if (response.statusCode != 200) {
        print(response.statusCode);
        if (responseData['code'] != 1000) {
          print(responseData['message']);
        }
      }
      final result = responseData['result'];

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
