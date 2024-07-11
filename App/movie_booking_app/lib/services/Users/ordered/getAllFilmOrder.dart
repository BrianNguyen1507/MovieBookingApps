import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;

class FilmOrder {
  static Future<List<OrderResponse>> getAllFilmOrder() async {
    
    final getURL = dotenv.env['GET_ALL_FILM_ORDER']!;
    final url = getURL;
    dynamic token = await Preferences().getTokenUsers();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
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

      List<OrderResponse> filmOrders = List<OrderResponse>.from(
          result.map((filmOrder) => OrderResponse.fromJson(filmOrder)));
      return filmOrders;
    } catch (err) {
      throw Exception(err);
    }
  }
}
