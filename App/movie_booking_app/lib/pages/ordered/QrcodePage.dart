import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/converter/converter.dart';

class QrcodePage extends StatelessWidget {
  const QrcodePage({super.key, required this.qr});
  final String qr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR CODE"),
        backgroundColor: AppColors.backgroundColor.withOpacity(0.2),
        titleTextStyle: AppStyle.headline1,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.iconThemeColor,
        ),
      ),
      body: Center(child: Image.memory(ConverterUnit.base64ToUnit8(qr))),
      backgroundColor: AppColors.iconThemeColor,
    );
  }
}
