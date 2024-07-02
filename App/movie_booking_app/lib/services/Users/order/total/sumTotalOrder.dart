import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/models/order/Total.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class GetTotalService {
  static Future<GetTotal> sumTotalOrder(
      int movieId, int quantity, List? food) async {
    Preferences pref = Preferences();
    String? token = await pref.getTokenUsers();
    const url = 'http://$ipAddress:8083/cinema/sumTotalOrder';

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

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final getData = result['result'];
      if (result['code'] != 1000) {
        throw Exception(result['message']);
      }

      return GetTotal(
        priceMovie: getData['priceTicket'],
        priceFood: getData['priceFood'],
        total: getData['total'],
      );
    } else {
      throw Exception('Failed to sum total order: ${response.statusCode}');
    }
  }
}