import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class FoodService {
  static ValidInput valid = ValidInput();

  static Future<List<Food>?> getAllFood(context) async {
    try {
      final getUrl = dotenv.env['GET_ALL_FOOD']!;

      final response = await http.get(
        Uri.parse(getUrl),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        debugPrint('Food status code: ${response.statusCode}');
      }
      final result = jsonDecode(utf8.decode(response.body.codeUnits));
      if (result['code'] != 1000) {
        debugPrint('Error Code: ${result['message']}');
      }

      final List<dynamic> data = result['result'];
      List<Food> foods = data.map((item) => Food.fromJson(item)).toList();

      return foods;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
