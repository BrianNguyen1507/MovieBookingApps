import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_ticket_scanner/response/response.dart';

class ConverterData {
  static Future<Uint8List> bytesToImage(String base64String) async {
    return const Base64Decoder().convert(base64String);
  }

  static String formatToDmY(String dateTimeString) {
    DateTime date = DateTime.parse(dateTimeString);
    DateFormat dateformat = DateFormat('dd-MM-yyyy');
    return dateformat.format(date);
  }

  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'en_US');
    String formatted = formatter.format(price);
    return formatted.replaceAll(',', '.');
  }

  static void confirmSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận thành công!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void confirmFail(BuildContext context, int code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận không thành công!'),
          content: Text(ValidReponse.getMessage(code, context)),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
