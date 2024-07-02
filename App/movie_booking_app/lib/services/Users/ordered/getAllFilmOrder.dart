import 'dart:convert';

import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/ordered/OrderFilmRespone.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;

class FilmOrder {
  static Future<List<OrderResponse>> getAllFilmOrder() async {
    const url = 'http://$ipAddress:8083/cinema/getAllFilmOrder';
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

      List<OrderResponse> filmOrders = List<OrderResponse>.from(result.map((filmOrder) => OrderResponse.fromJson(filmOrder)));
      return filmOrders;
    } catch (err) {
      throw Exception(err);
    }
  }
}
