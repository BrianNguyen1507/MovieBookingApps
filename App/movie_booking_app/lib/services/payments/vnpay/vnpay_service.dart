import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/services/payments/vnpay/vnpay_response.dart';

class Vnpayservice {
  static Future<VnPayResponse> vnPayCreateOrder(int total) async {
    try {
      final getUri = dotenv.env['VNPAY_CREATE_ORDER']!;

      final url = getUri + total.toString();

      dynamic token = await Preferences().getTokenUsers();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        
        
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Cannot create order with code: ${response.statusCode}');
      }
      final result = jsonDecode(response.body);
      if (result['code'] != 1000) {
        throw Exception('Error: ${result['message']}');
      }
      final vnPayResponse = VnPayResponse.fromJson(result['result']);
      return vnPayResponse;
    } catch (err) {
      throw Exception('Cannot create order: $err');
    }
  }
}
