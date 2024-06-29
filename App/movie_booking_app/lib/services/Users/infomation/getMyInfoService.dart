import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class MyInformation{
  static Future<Account> getMyInformation() async{
    Preferences pref = Preferences();
    String? token = await pref.getTokenUsers();
    const url = 'http://$ipAddress:8083/cinema/getMyInfo';
    try{
      final response = await http.get(
          Uri.parse(url),
        headers: {
            'Content-Type':'application/json;charset=UTF-8',
            'Authorization':'Bearer $token'
        }
      );
      final responseData = jsonDecode(utf8.decode(response.body.runes.toList()));
      if(response.statusCode!=200){
        print(response.statusCode);
        if(responseData['code']!=1000){
          print(responseData['message']);
        }
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
    }catch(err){
      throw Exception(err);
    }
  }
}