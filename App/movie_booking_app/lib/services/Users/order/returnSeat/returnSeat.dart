import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class ReturnSeatService {
  static Future<bool> returnSeat(
      context, int scheduleId, Set<String> seats) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();
      String seatString = ConverterUnit.convertSetToString(seats);

      final getURL = dotenv.env['RETURN_SEAT']!;
      final url = getURL
          .replaceAll('{scheduleId}', scheduleId.toString())
          .replaceAll('{seatString}', seatString);
      final response = await http.post(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode != 200) {
        debugPrint('Error return seat code: ${response.statusCode}');
      }
      final result = jsonDecode(response.body);
      if (result['code'] != 1000) {
        debugPrint('Invalid: ${result['message']}');
      }
      debugPrint('tra ghe  thanh cong');
      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}
