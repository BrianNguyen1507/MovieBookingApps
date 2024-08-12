import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/models/account/account.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateAccount {
  static ValidInput valid = ValidInput();

  static Future<Account?> updateAccount(Account account, context) async {
    final getURL = dotenv.env['UPDATE_INFO']!;
    final url = getURL;
    final bodyRequest = jsonEncode(account.toJson());
    Preferences preferences = Preferences();
    dynamic token = await preferences.getTokenUsers();
    try {
      final response = await http.put(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: bodyRequest);
      if (response.statusCode != 200) {
        debugPrint('${response.statusCode}');
      }
      final responseData =
          jsonDecode(utf8.decode(response.body.runes.toList()));
      if (responseData['code'] != 1000) {
        valid.showMessage(
            context, responseData['message'], AppColors.errorColor);
      }
      final result = responseData['result'];
      Preferences().setAvatar(result['avatar']);
      Preferences().setUserName(result['fullName']);
      valid.showMessage(context, AppLocalizations.of(context)!.update_success,
          AppColors.correctColor);

      return Account.fromJson(result);
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
      return null;
    } catch (err) {
      ShowMessage.unExpectedError(context);
      return null;
    }
  }
}
