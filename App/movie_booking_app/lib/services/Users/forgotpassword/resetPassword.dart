import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ResetPasswordService {
  static Future<String> resetPassword(String email, String password) async {
    
    final getUrl = dotenv.env['RESET_PASSWORD']!;
    final url = getUrl;
    final body = json.encode({'email': email, 'password': password});
    try {
      final response = await http.put(Uri.parse(url),
          headers: {'Content-Type': "application/json"}, body: body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['code'] == 1000) {
          return responseData['result']['email'];
        }
      }
    } catch (error) {
      throw Exception(error);
    }
    return "";
  }
}
