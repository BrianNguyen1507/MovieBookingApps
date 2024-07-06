import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class RatingFeedbackService{
  static Future<void>  createRatingFeedback(int rating, String comment,int orderId,BuildContext context) async{
    ValidInput valid = ValidInput();
    final uri = 'http://$ipAddress:8083/cinema/createRatingFeedBack?orderId=$orderId';
    final token = await Preferences().getTokenUsers();
    final body = jsonEncode(
        {
          'rating': rating,
          'comment': comment??"",
        }
        );
    try{
      final response = await http.post(
          Uri.parse(uri),
        headers: {
            'Content-Type':'application/json',
            'Authorization':'Bearer $token'
        },
        body: body,
      );
      final result = jsonDecode(utf8.decode(response.body.runes.toList()));
      if(response.statusCode==200){
        if(result['code']!=1000){
          valid.showMessage(context, result['message'], AppColors.correctColor);
          return;
        }
      }
      else {
        valid.showMessage(context,result['message'], AppColors.errorColor);
      }
    }catch(err){
      throw Exception(err);
    }
  }
}