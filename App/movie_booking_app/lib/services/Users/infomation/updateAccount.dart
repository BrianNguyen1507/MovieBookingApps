import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class UpdateAccount {
  static ValidInput valid = ValidInput();
  static Future<Account> updateAccount(Account account,BuildContext context) async {
    const url = 'http://$ipAddress:8083/cinema/updateAccount';
    final bodyRequest = jsonEncode(account.toJson());
    Preferences preferences = Preferences();
    dynamic token = await preferences.getTokenUsers();
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
        valid.showMessage(context, responseData['message'], AppColors.errorColor);
      }
     final result = responseData['result'];
     Preferences().setAvatar(result['avatar']);
      Preferences().setUserName(result['fullName']);
      valid.showMessage(context, "Update successfully",
          AppColors.correctColor);
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