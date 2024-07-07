import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static Future<bool> forgotPassword(String email) async {
    await dotenv.load();
    final getUrl = dotenv.env['FORGOT_PASSWORD']!;
    var url = getUrl + email;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['code'] == 1000) {
          return true;
        }
      }
    } catch (error) {
      throw Exception(error);
    }
    return false;
  }
}
