import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';

class CreateOrderService {
  static Future<bool> createOrderTicket(
    int scheduleId,
    int voucherId,
    String payMethod,
    String payCode,
    String seats,
    List<Map<String, dynamic>> foods,
    double sumTotal,
  ) async {
    try {
      const url = 'http://$ipAddress:8083/cinema/createOrder';
      final token = await Preferences().getTokenUsers();
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'movieScheduleId': scheduleId,
          'voucherId': voucherId,
          'paymentMethod': payMethod,
          'paymentCode': payCode,
          'seat': seats,
          'food': foods,
          'sumTotal': sumTotal,
        }),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['code'] != 1000) {
          return false;
        }
        print('SUCCESS!');
        return true;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception("cant create order: $err");
    }
  }
}
