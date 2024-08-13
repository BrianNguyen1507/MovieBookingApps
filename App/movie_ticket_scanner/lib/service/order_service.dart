import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/order.dart';

class OrderService {
  static Future<Result?> detailOrderByCode(String code) async {
    final baseUrl = dotenv.env['GET_DETAIL_ORDER']!;
    final url = baseUrl + code;
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode != 200) {
      debugPrint('Error get data order with code: ${response.statusCode}');
      return null;
    }

    final result = json.decode(utf8.decode(response.body.codeUnits));
    if (result['code'] != 1000) {
      debugPrint('Error get data order with message: ${result['message']}');
      return null;
    }

    return Result.fromJson(result['result']);
  }

  static Future<int> confirmOrder(int id) async {
    final baseUrl = dotenv.env['CONFIRM_ORDER']!;
    final uri = baseUrl + id.toString();
    final responseConfirm = await http.post(
      Uri.parse(uri),
      headers: {'Content-type': 'application/json'},
    );

    if (responseConfirm.statusCode != 200) {
      debugPrint(
          'Error get data order with code: ${responseConfirm.statusCode}');
    }

    final result = json.decode(responseConfirm.body);
    if (result['code'] != 1000) {
      debugPrint('Error get data order with message: ${result['message']}');

      return result['code'];
    }
    return result['code'];
  }
}
