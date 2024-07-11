import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
      
      final getURL = dotenv.env['CREATE_ORDER']!;
      final url = getURL;
      final token = await Preferences().getTokenUsers();
      final body = jsonEncode({
        'movieScheduleId': scheduleId,
        'voucherId': voucherId,
        'paymentMethod': payMethod,
        'paymentCode': payCode,
        'seat': seats,
        'food': foods,
        'sumTotal': sumTotal,
      });
      print(body);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      final result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (result['code'] != 1000) {
          return false;
        }
        print('CREATE ORDER SUCCESS!');
        return true;
      } else {
        print("${result['message']}");
        print('ERROR MESSAGE: ${result['message']}');
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (err) {
      throw Exception("cant create order: $err");
    }
  }
}
