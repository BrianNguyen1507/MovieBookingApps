import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/response/response.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';

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
      final apiResponse = Response<List<Food>>.fromJson(result, (json) {
        final List<dynamic> getData = json as List<dynamic>;
        return getData.map((item) => Food.fromJson(item)).toList();
      });
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        debugPrint('Error Code: ${result['message']}');
        return null;
      }
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
