import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_booking_app/models/ratingfeedback/rating_feedback.dart';
import 'package:movie_booking_app/modules/valid/show_message.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/response/error_code.dart';
import 'package:movie_booking_app/response/response.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';

class RatingFeedbackService {
  static Future<bool> createRatingFeedback(
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

      final apiReponse = ResponseFunction.fromJson(result, (data) {
        return data as dynamic;
      }, context);

      if (!apiReponse.isSuccess) {
        ShowDialog.showAlertCustom(
            context,
            true,
            ResponseCode.getMessage(apiReponse.code, context)!.message,
            null,
            true,
            null,
            DialogType.error);

        return false;
      }
      return true;
    } on SocketException {
      ShowMessage.noNetworkConnection(context);
      return false;
    } catch (err) {
      ShowMessage.unExpectedError(context);
      return false;
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
      final apiResponse = ResponseFunction.fromJson(result, (data) {
        final List<dynamic> ratingList = data as List<dynamic>;
        return ratingList.map((json) => RatingFeedback.fromjson(json)).toList();
      }, context);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
      } else {
        ShowMessage.unExpectedError(context);
        debugPrint(
            'Error get all rating service message: ${result['message']}');
      }
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
        debugPrint('Error get all rating service code: ${response.statusCode}');
      }
      final apiResponse = ResponseFunction.fromJson(result, (data) {
        return data as dynamic;
      }, context);
      if (apiResponse.isSuccess) {
        return apiResponse.result;
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
