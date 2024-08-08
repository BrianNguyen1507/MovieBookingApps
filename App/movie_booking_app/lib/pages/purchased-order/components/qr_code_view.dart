import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';

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
      appBar: Common.customAppbar(context, null, AppStyle.headline2, 'QR CODE',
          AppColors.iconThemeColor, AppColors.appbarColor.withOpacity(0.3)),
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
      debugPrint("Failed to set max brightness: '${e.message}'.");
    }
  }

  void _resetBrightness() async {
    try {
      await QrcodePage.brightnessChannel.invokeMethod('resetBrightness');
    } on PlatformException catch (e) {
      debugPrint("Failed to reset brightness: '${e.message}'.");
    }
  }
}
