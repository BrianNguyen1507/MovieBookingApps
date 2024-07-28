import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_ticket_scanner/qrScanPage.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    const MaterialApp(
      home: QRScannPage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
