import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/ordered/order_movie_response.dart';
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:http/http.dart' as http;

class FilmOrder {
  static Future<List<OrderResponse>?> getAllFilmOrder(context) async {
    final getURL = dotenv.env['GET_ALL_FILM_ORDER']!;
    final url = getURL;
    dynamic token = await Preferences().getTokenUsers();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      });
      if (response.statusCode != 200) {
        debugPrint('Error get all movie order code: ${response.statusCode}');
      }
      final responseData =
          jsonDecode(utf8.decode(response.body.runes.toList()));
      final apiResponse =
          ResponseFunction<List<OrderResponse>>.fromJson(responseData, (data) {
        final List<dynamic> listData = data as List<dynamic>;
        return listData.map((item) => OrderResponse.fromJson(item)).toList();
      }, context);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        debugPrint('Error get all movie order message: ${apiResponse.message}');
      }
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
