import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class CreateOrderService {
  static Future<bool> createOrderTicket(
    context,
    int scheduleId,
    int voucherId,
    String payMethod,
    String payCode,
    String seats,
    List<Map<String, dynamic>> foods,
    double sumTotal,
  ) async {
    try {
      final getURL = dotenv.env['CREATE_ORDER']!;
      final url = getURL;
      final token = await Preferences().getTokenUsers();
      final body = jsonEncode({
        'movieScheduleId': scheduleId,
        'voucherId': voucherId,
        'paymentMethod': payMethod,
        'paymentCode': payCode,
        'seat': seats,
        'food': foods,
        'sumTotal': sumTotal,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      final result = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint('Error create Order code: ${response.statusCode}');
      }
      if (result['code'] != 1000) {
        debugPrint('Error create Order code: ${result['message']}');
        return false;
      }
      debugPrint('CREATE ORDER SUCCESS!');
      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return false;
  }
}
