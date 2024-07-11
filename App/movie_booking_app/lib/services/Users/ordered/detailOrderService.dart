import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/ordered/DetailOrder.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;

class DetailOrderService {
  static Future<DetailOrder> detailOrder(int id) async {
    try {
      
      final getURL = dotenv.env['GET_DETAIL_ORDER_BY_ID']!;
      final uri = getURL + id.toString();
      dynamic token = await Preferences().getTokenUsers();
      final response = await http.get(Uri.parse(uri), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode != 200) {
        print(response.statusCode);
      }
      final responseData =
          jsonDecode(utf8.decode(response.body.runes.toList()));
      if (responseData['code'] != 1000) {
        print(responseData['message']);
      }
      final result = responseData['result'];
      DetailOrder order = DetailOrder.fromJson(result);

      return order;
    } catch (err) {
      throw Exception(err);
    }
  }
}
