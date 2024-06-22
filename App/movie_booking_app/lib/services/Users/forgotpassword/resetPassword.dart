import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';

class ResetPasswordService{
    static Future<String> resetPassword(String email, String password) async{
        const url ='http://$ipAddress:8083/cinema/resetPassword';
        final body = json.encode({
            'email': email,
            'password':password
        });
        try{
            final response = await http.put(
                Uri.parse(url),
                headers: {'Content-Type':"application/json"},
                body: body
            );
            if(response.statusCode==200){
                final responseData =  json.decode(response.body);
                if(responseData['code']==1000){

                    return responseData['result']['email'];
                }
            }
        }catch(error){
            throw Exception(error);
        }
        return "";
    }
}