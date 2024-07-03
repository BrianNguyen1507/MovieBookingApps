import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/food/food.dart';
import 'package:http/http.dart' as http;

class FoodService {
  static Future<List<Food>> getAllFood() async {
    try {
      const url = 'http://$ipAddress:8083/cinema/getAllFood';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] != 1000) {
          return result['message'];
        }
        final List<dynamic> data = result['result'];
        List<Food> foods = data
            .map(
              (item) => Food(
                id: item['id'],
                name: item['name'],
                price: item['price'],
                image: item['image'],
                quantity: item['quantity'],
              ),
            )
            .toList();

        return foods;
      } else {
        throw Exception('Error with status code ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('cant fetching data food $err');
    }
  }
}
