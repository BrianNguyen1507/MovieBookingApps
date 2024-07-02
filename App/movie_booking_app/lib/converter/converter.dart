import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

class ConverterUnit {
  static Uint8List base64ToUnit8(String base64String) {
    List<int> bytes = base64Decode(base64String);
    return Uint8List.fromList(bytes);
  }

  static String convertToUtf8(String input) {
    List<int> utf8Bytes = utf8.encode(input);
    String decodedString = utf8.decode(utf8Bytes);
    return decodedString;
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

  static String formatToDmY(String dateTimeString) {
    DateTime date = DateTime.parse(dateTimeString);
    DateFormat dateformat = DateFormat('dd-MM-yyyy');
    return dateformat.format(date);
  }

  static String formatTimeToHhmm(String timeString) {
    DateFormat inputFormat = DateFormat('HH:mm:ss');
    DateFormat timeFormat = DateFormat('HH:mm');
    DateTime time = inputFormat.parse(timeString);
    return timeFormat.format(time);
  }

  static String uint8ToString(Uint8List data) {
    return utf8.decode(data);
  }

  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'en_US');
    String formatted = formatter.format(price);
    return formatted.replaceAll(',', '.');
  }

  static List<int> caculateMonth() {
    DateTime now = DateTime.now();
    List<int> listMonth = [];
    for (int month = now.month; month <= 12; month++) {
      listMonth.add(month);
    }
    return listMonth;
  }

  static String convertSetToString(Set<String> seats) {
    return seats.join(',');
  }

  static Set<String> convertStringToSet(String seatsString) {
    List<String> seatList = seatsString.split(',');
    return seatList.toSet();
  }
  static String formatdMYhm(DateTime date) {
    final DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
    return formatter.format(date);
  }
}
