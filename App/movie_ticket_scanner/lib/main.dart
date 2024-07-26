import 'package:flutter/material.dart';
import 'package:movie_ticket_scanner/scannerPage.dart';

void main() {
  runApp(const ScannerApp());
}

class ScannerApp extends StatelessWidget {
  const ScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'STU SCANNER',
      home: ScannerPageView(),
    );
  }
}
