import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/order/get_total.dart';
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';

class GetTotalService {
  static Future<GetTotal?> sumTotalOrder(
      context, int movieId, int quantity, List? food) async {
    Preferences pref = Preferences();
    String? token = await pref.getTokenUsers();

    final getURL = dotenv.env['GET_SUM_TOTAL']!;
    final url = getURL;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'idFilm': movieId,
        'quantitySeat': quantity,
        'food': food,
      }),
    );

    if (response.statusCode != 200) {
      debugPrint('Error sumtotal Service code: ${response.statusCode}');
    }
    final result = jsonDecode(response.body);

    final apiResponse = ResponseFunction<GetTotal>.fromJson(
      result,
      (json) {
        final dynamic data = json as dynamic;
        return GetTotal.fromJson(data);
      },
      context,
    );

    if (apiResponse.isSuccess) {
      return apiResponse.result!;
    } else {
      debugPrint('Error sumtotal Service message: ${apiResponse.message}');
      return null;
    }
  }
}
