import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/show_message.dart';

class ForgotPasswordService {
  static Future<bool> forgotPassword(String email, context) async {
    final baseUrl = dotenv.env['FORGOT_PASSWORD']!;
    final url = '$baseUrl$email';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode != 200) {
        debugPrint('Error in forgotPassword: ${response.statusCode}');
        return false;
      }
      final responseData = json.decode(response.body);
      if (responseData['code'] != 1000) {
        return false;
      }
      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}
