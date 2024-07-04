import 'package:http/http.dart' as http;
import 'package:movie_booking_app/constant/ZaloConfig.dart';
import 'package:movie_booking_app/services/payments/ZaloPay/zaloResponse/CreateOrder.dart';
import 'dart:convert';
import 'package:movie_booking_app/constant/ZaloConfig.dart' as utils;
import 'package:sprintf/sprintf.dart';

class ZaloPayService {
  static const String appId = "2554";
  static const String key1 = "sdngKKJmqEMzvh5QQcdD2A9XBSKUNaYn";
  static const String key2 = "trMrHtvjo6myautxDUiAcYsVtaeQ8nhf";

  static const String appUser = "STU Cinemas";
  static int transIdDefault = 1;
}

Future<CreateOrderResponse?> createOrder(
    int price, List<Map<String, dynamic>> items) async {
  final headers = {
    "Content-Type": "application/x-www-form-urlencoded",
  };

  final appTime = DateTime.now().millisecondsSinceEpoch.toString();
  final appTransId = utils.getAppTransId();
  final body = {
    "app_id": ZaloPayService.appId,
    "app_user": ZaloPayService.appUser,
    "app_time": appTime,
    "amount": price.toString(),
    "app_trans_id": appTransId,
    "embed_data": "{}",
    "item": "[]",
    "bank_code": utils.getBankCode(),
    "description": utils.getDescription(appTransId),
  };

  final dataGetMac = sprintf("%s|%s|%s|%s|%s|%s|%s", [
    body["app_id"],
    body["app_trans_id"],
    body["app_user"],
    body["amount"],
    body["app_time"],
    body["embed_data"],
    body["item"],
  ]);

  body["mac"] = utils.getMacCreateOrder(dataGetMac);

  try {
    final response = await http.post(
      Uri.parse(Endpoints.createOrderUrl),
      headers: headers,
      body: body,
    );

    print("body_request: $body");
    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);
    print("data_response: $data");

    return CreateOrderResponse.fromJson(data);
  } catch (e) {
    print("Error: $e");
    return null;
  }
}
