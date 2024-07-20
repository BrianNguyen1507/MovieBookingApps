import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/services/payments/ZaloPay/CreateOrder.dart';
import 'dart:convert';
import 'package:movie_booking_app/services/payments/ZaloPay/ZaloConfig.dart'
    as utils;
import 'package:sprintf/sprintf.dart';

Future<CreateOrderResponse?> createOrder(int price) async {
  final headers = {
    "Content-Type": "application/x-www-form-urlencoded",
  };

  final appTime = DateTime.now().millisecondsSinceEpoch.toString();
  final appTransId = utils.getAppTransId();

  final getAppId = dotenv.env['ZALO_APP_ID'];
  final getAppUser = dotenv.env['ZALO_APP_USER'];
  final body = {
    "app_id": getAppId,
    "app_user": getAppUser,
    "app_time": appTime,
    "amount": price.toString(),
    "app_trans_id": appTransId,
    "embed_data": "{}",
    "item": '[]',
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

  body["mac"] = await utils.getMacCreateOrder(dataGetMac);

  try {
    final getUrl = dotenv.env['ZALO_CREATE_ORDER']!;
    final response = await http.post(
      Uri.parse(getUrl),
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
