import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/models/response/response.dart';
import 'package:movie_booking_app/models/voucher/voucher.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';

class VoucherService {
  static Future<List<Voucher>> getAllVoucherByAccount(
      context, double total) async {
    try {
      Preferences pref = Preferences();
      dynamic token = await pref.getTokenUsers();

      final getURL = dotenv.env['GET_ALL_VOUCHER_BY_ACCOUNT']!;
      final url = getURL + total.toString();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        debugPrint(
            'Error get all voucher service code: ${response.statusCode}');
      }
      final Map<String, dynamic> result =
          jsonDecode(utf8.decode(response.body.codeUnits));
      final apiResponse = Response<List<Voucher>>.fromJson(result, (data) {
        final List<dynamic> voucherData = data as List<dynamic>;
        return voucherData.map((item) => Voucher.fromJson(item)).toList();
      });
      if (apiResponse.isSuccess) {
        return apiResponse.result!;
      } else {
        debugPrint(
            'Error get all voucher service message: ${apiResponse.message}');
        return [];
      }
    } catch (err) {
      ShowMessage.unExpectedError(context);
      return [];
    }
  }

  static Future<List<Voucher>?> getVoucherByEmail(context) async {
    try {
      final getUri = dotenv.env['GET_ALL_VOUCHER']!;
      dynamic token = await Preferences().getTokenUsers();

      final response = await http.get(
        Uri.parse(getUri),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final result = jsonDecode(utf8.decode(response.body.codeUnits));
      if (response.statusCode != 200) {
        debugPrint(
            'Error getVoucherByEmail service code: ${response.statusCode}');
      }
      final apiResponse = Response<List<Voucher>>.fromJson(result, (data) {
        final List<dynamic> getVoucher = data as List<dynamic>;
        return getVoucher.map((item) => Voucher.fromJson(item)).toList();
      });
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        debugPrint(
            'Error getVoucherByEmail service message: ${apiResponse.message}');
      }
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
