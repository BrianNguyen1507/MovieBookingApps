import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class UpdateAccount {
  static Future<Account> updateAccount(Account account) async {
    const url = 'http://$ipAddress:8083/cinema/updateAccount';
    final bodyRequest = jsonEncode(account.toJson());
    Preferences preferences = Preferences();
    String? token = await preferences.getTokenUsers();
    try {
      final response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: bodyRequest
      );
      if(response.statusCode!=200){
        print(response.statusCode);
      }
      final responseData = jsonDecode(utf8.decode(response.body.runes.toList()));
      if(responseData['code']!=1000){
        print(responseData['message']);
      }
     final result = responseData['result'];
      Account account =Account(
          email: result['email']?? "",
          avatar: result['avatar']?? "",
          fullName: result['fullName']?? "",
          phoneNumber: result['phoneNumber']?? "",
          gender: result['gender']?? "",
          dayOfBirth:  result['dayOfBirth'])
      ;
      return account;
    } catch (err) {
      throw Exception(err);
    }
  }
}