import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

class ConverterUnit {
  static Uint8List base64ToUnit8(String base64String) {
    List<int> bytes = base64Decode(base64String);
    return Uint8List.fromList(bytes);
  }

  static Future<Uint8List> bytesToImage(String base64String) async {
    try {
      Uint8List imgBytes = base64Decode(base64String);
      return imgBytes;
    } catch (e) {
      rethrow;
    }
  }

  static String convertToDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(dateTime);
  }

  static String uint8ToString(Uint8List data) {
    return utf8.decode(data);
  }

  static List<int> caculateMonth() {
    DateTime now = DateTime.now();
    List<int> listMonth = [];
    for (int month = now.month; month <= 12; month++) {
      listMonth.add(month);
    }
    return listMonth;
  }
}
