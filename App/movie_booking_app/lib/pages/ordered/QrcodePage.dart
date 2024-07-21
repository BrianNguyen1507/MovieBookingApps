import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QrcodePage extends StatefulWidget {
  const QrcodePage({super.key, required this.qr});
  final String qr;
  static MethodChannel brightnessChannel =
      const MethodChannel('flutter.native/IncreaseBrightness');

  @override
  State<QrcodePage> createState() => _QrcodePageState();
}

class _QrcodePageState extends State<QrcodePage> {
  @override
  void initState() {
    super.initState();
    _setMaxBrightness();
  }

  @override
  void dispose() {
    super.dispose();
    _resetBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR CODE"),
        backgroundColor: AppColors.backgroundColor.withOpacity(0.2),
        titleTextStyle: AppStyle.headline1,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.backgroundColor,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Image.memory(ConverterUnit.base64ToUnit8(widget.qr))),
          Text(
            AppLocalizations.of(context)!.note1,
            style: AppStyle.smallText,
          ),
          Text(
            AppLocalizations.of(context)!.note2,
            style: AppStyle.smallText,
          )
        ],
      ),
      backgroundColor: AppColors.iconThemeColor,
    );
  }

  void _setMaxBrightness() async {
    try {
      await QrcodePage.brightnessChannel.invokeMethod('setMaxBrightness');
    } on PlatformException catch (e) {
      print("Failed to set max brightness: '${e.message}'.");
    }
  }

  void _resetBrightness() async {
    try {
      await QrcodePage.brightnessChannel.invokeMethod('resetBrightness');
    } on PlatformException catch (e) {
      print("Failed to reset brightness: '${e.message}'.");
    }
  }
}
