import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/response/response.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';

class HoldSeatService {
  static Future<bool> holdSeat(
      context, int scheduleId, Set<String> seats) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();
      String seatString = ConverterUnit.convertSetToString(seats);

      final getURL = dotenv.env['HOLD_SEAT']!;
      final url = getURL
          .replaceAll('{scheduleId}', scheduleId.toString())
          .replaceAll('{seatString}', seatString);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint('Error Hold seat Code: ${response.statusCode}');
        return false;
      }
      if (result['code'] != 1000) {
        debugPrint('Invalid: ${result['message']}');
        return false;
      }

      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (e) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }

  static Future<bool> checkHoldSeat(
      context, int? scheduleId, String? seats) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();

      final getURL = dotenv.env['CHECK_SEAT_VALID']!;
      final url = getURL
          .replaceAll('{scheduleId}', scheduleId.toString())
          .replaceAll('{seatString}', seats!);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final result = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint('Error Hold seat Code: ${response.statusCode}');
        return false;
      }
      final apiResponse = Response.fromJson(
        result,
        (json) {
          return json as bool;
        },
      );
      if (apiResponse.isSuccess && apiResponse.result == true) {
        return true;
      }

      return false;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (e) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}
