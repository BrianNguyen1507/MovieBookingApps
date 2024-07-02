import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';

import 'package:http/http.dart' as http;
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class VoucherApply {
  static Future<double> applyVoucher(int voucherId, double total) async {
    dynamic token = await Preferences().getTokenUsers();
    final url =
        'http://$ipAddress:8083/cinema/applyVoucher?voucherId=$voucherId&price=$total';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['code'] != 1000) {
        return result['message'];
      }
      double total = result['result'];
      return total;
    } else {
      throw Exception('error with code: ${response.statusCode}');
    }
  }
}
