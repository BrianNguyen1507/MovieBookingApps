import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/response/error_code.dart';
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';

class ResetPasswordService {
  static Future<String?> resetPassword(
      String email, String password, String otp, context) async {
    final getUrl = dotenv.env['RESET_PASSWORD']!;
    final url = getUrl;
    final body = json.encode({
      'email': email,
      'password': password,
      'otp': otp,
    });
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': "application/json"},
        body: body,
      );

      final responseData = json.decode(response.body);
      final apiResponse = ResponseFunction.fromJson(responseData, (data) {
        return data as dynamic;
      }, context);
      if (!apiResponse.isSuccess) {
        ShowDialog.showAlertCustom(
          context,
          true,
          ResponseCode.getMessage(responseData['code'], context)!.message,
          null,
          true,
          null,
          DialogType.error,
        );

        return null;
      }

      return apiResponse.result['email'];
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
