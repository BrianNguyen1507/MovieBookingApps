import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:http/http.dart' as http;

class FindFoodService {
  static Future<Food> getFoodById(String id) async {
    try {
      
      final baseUrl = dotenv.env['GET_FOOD_BY_ID']!;
      final url = baseUrl + id;
      final response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(utf8.decode(response.body.codeUnits));
        if (result['code'] != 1000) {
          return result['message'];
        }
        final data = result['result'];

        return Food.fromJson(data);
      } else {
        throw Exception('error with status code: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant fetching food $id : $err');
    }
  }
}
