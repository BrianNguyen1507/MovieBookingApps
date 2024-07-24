import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/ratingfeedback/RatingFeedback.dart';
import 'package:movie_booking_app/modules/valid/validException.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;

class RatingFeedbackService {
  static Future<dynamic> createRatingFeedback(
      int rating, String comment, int orderId, context) async {
    final getURL = dotenv.env['CREATE_RATING_FEEDBACK']!;
    final uri = getURL + orderId.toString();
    final token = await Preferences().getTokenUsers();
    final body = jsonEncode({
      'rating': rating,
      'comment': comment,
    });
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: body,
      );
      final result = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint('Error rating service code: ${response.statusCode}');
      }
      if (result['code'] != 1000) {
        debugPrint('Error rating service message: ${result['message']}');
        return result['message'];
      }
      return result['code'].toString();
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
  }

  static Future<List<RatingFeedback>?> getAllRatingFeedback(
      context, int movieId) async {
    try {
      final getURL = dotenv.env['GET_RATING_FEEDBACK']!;
      final url = getURL + movieId.toString();

      final responseFeedBack = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
      });
      final result =
          jsonDecode(utf8.decode(responseFeedBack.body.runes.toList()));

      if (responseFeedBack.statusCode != 200) {
        debugPrint(
            'Error get all rating service code: ${responseFeedBack.statusCode}');
      }
      if (result['code'] != 1000) {
        ShowMessage.unExpectedError(context);
        debugPrint(
            'Error get all rating service message: ${result['message']}');
      }

      List<RatingFeedback> listFeedback = List<RatingFeedback>.from(
          result['result']
              .map((feedback) => RatingFeedback.fromjson(feedback)));

      return listFeedback;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }

  static Future<RatingFeedback?> getRatingFeedback(
      context, BigInt orderId) async {
    final getURL = dotenv.env['GET_RATING_FEEDBACK_BY_ORDER_ID']!;
    final uri = getURL + orderId.toString();
    final token = await Preferences().getTokenUsers();
    try {
      final response = await http.get(
        Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      final result = jsonDecode(utf8.decode(response.body.runes.toList()));
      if (response.statusCode == 200) {
        if (result['code'] == 1000) {
          return RatingFeedback.fromjson(result['result']);
        }
      }
      return null;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
    } catch (err) {
      ShowMessage.unExpectedError(context);
    }
    return null;
  }
}
