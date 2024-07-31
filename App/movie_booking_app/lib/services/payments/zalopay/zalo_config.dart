import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:sprintf/sprintf.dart';

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

Future<String> getMacCreateOrder(String data) async {
  
  final getKey = dotenv.env['ZALO_KEY1']!;
  var hmac = Hmac(sha256, utf8.encode(getKey));
  return hmac.convert(utf8.encode(data)).toString();
}
