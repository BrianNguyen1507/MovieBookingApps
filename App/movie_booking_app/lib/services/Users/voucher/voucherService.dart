import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class VoucherService {
  static Future<List<Voucher>> getAllVoucherByAccount(double total) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();

      final getURL = dotenv.env['GET_ALL_VOUCHER_BY_ACCOUNT']!;
      final url = getURL + total.toString();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result =
            jsonDecode(utf8.decode(response.body.codeUnits));

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

  static Future<List<Voucher>> getVoucherByEmail() async {
    try {
      final getUri = dotenv.env['GET_ALL_VOUCHER_BY_ACCOUNT_EMAIL']!;
      dynamic token = await Preferences().getTokenUsers();
      dynamic email = await Preferences().getEmail();

      final response = await http.get(
        Uri.parse(getUri + email),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final result = jsonDecode(utf8.decode(response.body.codeUnits));
      if (response.statusCode == 200) {
        if (result['code'] != 1000) {
          return result['message'];
        }
        final List accountVouchers = result['result'];
        return accountVouchers.map((av) => Voucher.fromJson(av)).toList();
      } else {
        throw Exception('error with code ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant fetching data voucher by account email $err');
    }
  }
}
