import 'dart:convert';
import 'dart:typed_data';

class ConverterUnit {
  static Uint8List base64ToUnit8(String base64String) {
    List<int> bytes = base64Decode(base64String);
    return Uint8List.fromList(bytes);
  }

  static Future<Uint8List> bytesToImage(String base64String) async {
    try {
      Uint8List imgBytes = base64Decode(base64String);
      return imgBytes;
    } catch (e) {
      rethrow;
    }
  }
}
