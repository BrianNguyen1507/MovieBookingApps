import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class VoucherApply {
  static Future<double?> applyVoucher(
      context, int voucherId, double total) async {
    try {
      dynamic token = await Preferences().getTokenUsers();

      final getURL = dotenv.env['APPLY_VOUCHER_BY_ID']!;
      final url = getURL
          .replaceAll('{voucherId}', voucherId.toString())
          .replaceAll('{total}', total.toString());
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200) {
        debugPrint('Error voucher apply service Code: ${response.statusCode}');

        return null;
      }
      final result = jsonDecode(response.body);
      if (result['code'] != 1000) {
        ShowMessage.unExpectedError(context);
        debugPrint('Error voucher apply service Code: ${result['message']}');
        return null;
      }
      double newTotal = result['result'];
      return newTotal;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
