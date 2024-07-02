import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;

class FoodOrderService {
  static Future<List<OrderResponse>> getAllFoodOrder() async {
    const url = 'http://$ipAddress:8083/cinema/getAllFoodOrder';
    String? token = await Preferences().getTokenUsers();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      });
      if(response.statusCode!=200){
        print(response.statusCode);
      }
      final responseData = jsonDecode(utf8.decode(response.body.runes.toList()));
      if(responseData['code']!=1000){
        print(responseData['message']);
      }
      final result = responseData['result'];

      List<OrderResponse> foodOrders = List<OrderResponse>.from(result.map((filmOrder) => OrderResponse.fromJson(filmOrder)));
      return foodOrders;
    } catch (err) {
      throw Exception(err);
    }
  }
}
