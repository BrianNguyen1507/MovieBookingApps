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
      const url = 'http://$ipAddress:8083/cinema/order';
      final token = await Preferences().getTokenUsers();
      final data = jsonEncode({
        'movieScheduleId': scheduleId,
        'voucherId': voucherId,
        'paymentMethod': payMethod,
        'paymentCode': payCode,
        'seat': seats,
        'food': foods,
        'sumTotal': sumTotal,
      });
      print(data);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: data,
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {

        if (result['code'] != 1000) {
          return false;
        }
        print("${result['result']}");
        return true;
      } else {
        print("${result['message']}");
      }
    } catch (err) {
      throw Exception("cant create order: $err");
    } return false;
  }
}
