import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/services/payments/ZaloPayService.dart';
import 'package:sprintf/sprintf.dart';

class Endpoints {
  static const String createOrderUrl =
      "https://sb-openapi.zalopay.vn/v2/create";
  static const String statusOrderUrl = "https://sb-openapi.zalopay.vn/v2/query";
}

int transIdDefault = 1;
String getAppTransId() {
  if (transIdDefault >= 100000) {
    transIdDefault = 1;
  }

  transIdDefault += 1;
  var timeString = formatDateTime(DateTime.now(), "yyMMdd_hhmmss");
  return sprintf("%s%06d", [timeString, transIdDefault]);
}

String getBankCode() => "zalopayapp";
String getDescription(String apptransid) =>
    "STU-Cinemas: thanh toán cho đơn hàng  #$apptransid";

String getMacCreateOrder(String data) {
  var hmac = new Hmac(sha256, utf8.encode(ZaloPayService.key1));
  return hmac.convert(utf8.encode(data)).toString();
}
