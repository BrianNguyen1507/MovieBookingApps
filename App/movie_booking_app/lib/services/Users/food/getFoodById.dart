import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:http/http.dart' as http;

class FindFoodService {
  static Future<Food> getFoodById(String id) async {
    try {
      final url = 'http://$ipAddress:8083/cinema/getFoodById?id=$id';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] != 1000) {
          return result['message'];
        }
        final data = result['result'];

        return Food(
          id: data['id'],
          name: data['name'],
          price: data['price'],
          image: data['image'],
        );
      } else {
        throw Exception('error with status code: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant fetching food $id : $err');
    }
  }
}
