import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class GetOrderInfo {
  static Future<int> accountNumberMovieInfo() async {
    try {
      final getUri = dotenv.env['GET_ALL_FILM_ORDER']!;
      dynamic token = await Preferences().getTokenUsers();
      final response = await http.get(Uri.parse(getUri), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      final result = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Future.error('Error: ${result['message']}');
      }

      if (result['code'] != 1000) {
        return Future.error('Error: ${result['message']}');
      }

      List<OrderResponse> filmOrders = List<OrderResponse>.from(result['result']
          .map((filmOrder) => OrderResponse.fromJson(filmOrder)));

      return filmOrders.length;
    } catch (err) {
      throw Exception('Unable to get order info: $err');
    }
  }

  static Future<int> accountNumberReviewInfo() async {
    try {
      final getUri = dotenv.env['GET_RATING_FEEDBACK_ACCOUNT_NUMBER']!;
      dynamic token = await Preferences().getTokenUsers();
      final response = await http.get(Uri.parse(getUri), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      final result = jsonDecode(response.body);

      if (response.statusCode != 200) {
        return Future.error('Error: ${result['message']}');
      }

      if (result['code'] != 1000) {
        return Future.error('Error: ${result['message']}');
      }

      final data = result['result'];
      return data;
    } catch (err) {
      throw Exception('Unable to get order info: $err');
    }
  }
}
