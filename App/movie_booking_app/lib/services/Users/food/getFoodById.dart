import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/modules/valid/validException.dart';

class FindFoodService {
  static Future<Food?> getFoodById(String id, context) async {
    try {
      final baseUrl = dotenv.env['GET_FOOD_BY_ID']!;
      final url = '$baseUrl$id';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });

      if (response.statusCode != 200) {
        debugPrint('food service err: ${response.statusCode}');
      }
      final result = jsonDecode(utf8.decode(response.body.codeUnits));
      if (result['code'] != 1000) {
        debugPrint(result['message']);
      }
      final data = result['result'];
      return Food.fromJson(data);
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
