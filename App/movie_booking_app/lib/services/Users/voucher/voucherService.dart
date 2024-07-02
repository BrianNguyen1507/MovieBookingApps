import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class VoucherService {
  static Future<List<Voucher>> getAllVoucherByAccount(double total) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();
      final url =
          'http://$ipAddress:8083/cinema/getAllVoucherByAccount?price=$total';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);

        if (result['code'] != 1000) {
          throw Exception(result['message']);
        }

        final List<dynamic> voucherList = result['result'];

        List<Voucher> vouchers = voucherList.map((data) {
          return Voucher(
            id: data['id'],
            title: data['title'],
            content: data['content'],
            typeDiscount: data['typeDiscount'],
            discount: data['discount'],
            minLimit: data['minLimit'],
            quantity: data['quantity'],
            expired: data['expired'],
            allowed: data['allow'] == true || data['allow'] == 'true',
          );
        }).toList();

        return vouchers;
      } else {
        throw Exception('Error with code: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Cannot fetch data: $err');
    }
  }
}
