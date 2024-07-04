import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/converter/converter.dart';

class QrcodePage extends StatelessWidget{
  const QrcodePage({super.key, required this.qr});
  final String qr;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("List Order"),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: AppFontSize.medium,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),body: Center(child: Image.memory(ConverterUnit.base64ToUnit8(qr))),
      backgroundColor: AppColors.backgroundColor,
    );
  }

}