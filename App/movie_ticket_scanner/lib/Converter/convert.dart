import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConverterData {
  static Future<Uint8List> bytesToImage(String base64String) async {
    return const Base64Decoder().convert(base64String);
  }

  static String formatToDmY(String dateTimeString) {
    DateTime date = DateTime.parse(dateTimeString);
    DateFormat dateformat = DateFormat('dd-MM-yyyy');
    return dateformat.format(date);
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

  static void confirmFail(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận không thành công!'),
          content: Text(message),
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
