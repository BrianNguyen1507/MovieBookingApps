import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';

class ResetPasswordService {
  static Future<String> resetPassword(
      String email, String password, context) async {
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
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return "";
  }
}
