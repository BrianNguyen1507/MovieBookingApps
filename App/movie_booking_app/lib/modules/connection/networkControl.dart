import 'package:flutter/services.dart';

class ConnectionController {
  static MethodChannel platform =
      const MethodChannel('flutter.native/internetConnection');
  static Future<bool> checkConnection() async {
    try {
      final bool result =
          await platform.invokeMethod('checkInternetConnection');
      return result;
    } on PlatformException catch (e) {
      print('connection internet check fail $e');
      return false;
    }
  }

  static void startListening(Function(bool) onStatusChange) {
    platform.setMethodCallHandler((call) async {
      if (call.method == "networkStatusChanged") {
        final bool isConnected = call.arguments;
        onStatusChange(isConnected);
      }
    });
  }
}
