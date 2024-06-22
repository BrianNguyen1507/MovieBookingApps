import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';

class ForgotPasswordService{
    static Future<String> forgotPassword(String email) async{
      var url = 'http://${ipAddress}:8083/cinema/forgotPassword?email=$email';
      try{

        final response = await http.get(
            Uri.parse(url),
            headers: {"Content-Type":"application/json"},
        );
        if(response.statusCode==200){
          final responseData = json.decode(response.body);
          if(responseData['code']==1000){
            return responseData['result']['email'].toString();
          }
        }
      }catch(error){
        throw Exception(error);
      }
      return "";
    }
}