import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/ordered/order_movie_response.dart';
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';

class GetOrderInfo {
  static Future<int?> accountNumberMovieInfo(context) async {
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

      final apiResponse =
          ResponseFunction<List<OrderResponse>>.fromJson(result, (data) {
        final List<dynamic> listOrder = data as List<dynamic>;
        return (listOrder.map((item) => OrderResponse.fromJson(item)).toList());
      }, context);
      if (apiResponse.isSuccess) {
        return apiResponse.result!.length;
      } else {
        debugPrint(('Error to fetch info message: ${apiResponse.message}'));
        return null;
      }
    } catch (err) {
      debugPrint(('Unable to get order info: $err'));
      return 0;
    }
  }

  static Future<int?> accountNumberReviewInfo(context) async {
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
      final apiResponse = ResponseFunction<int?>.fromJson(result, (data) {
        return data as int;
      }, context);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        debugPrint(('Error to fetch info message: ${apiResponse.message}'));
        return null;
      }
    } catch (err) {
      debugPrint(('Unable to get order info: $err'));
      return 0;
    }
  }
}
