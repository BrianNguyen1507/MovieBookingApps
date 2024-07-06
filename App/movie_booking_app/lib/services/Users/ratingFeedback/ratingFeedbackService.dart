import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_booking_app/config/ipconfig.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

import 'package:movie_booking_app/models/feedback/feedback.dart';

import 'package:movie_booking_app/models/ratingfeedback/RatingFeedback.dart';

import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:http/http.dart' as http;
import 'package:movie_booking_app/services/Users/signup/validHandle.dart';

class RatingFeedbackService {
  static Future<void> createRatingFeedback(
      int rating, String comment, int orderId, BuildContext context) async {
    ValidInput valid = ValidInput();
    final uri =
        'http://$ipAddress:8083/cinema/createRatingFeedBack?orderId=$orderId';
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
      final result = jsonDecode(utf8.decode(response.body.runes.toList()));
      if (response.statusCode == 200) {
        if (result['code'] != 1000) {
          valid.showMessage(context, result['message'], AppColors.errorColor);
          return;
        }
        valid.showMessage(context, 'Rating feedBack successful! Thanks you',
            AppColors.correctColor);
      } else {
        valid.showMessage(context, result['message'], AppColors.errorColor);
      }
    } catch (err) {
      throw Exception(err);
    }
  }


  static Future<List<RatingFeedback>> getAllRatingFeedback(int movieId) async {
    try {
      final url =
          'http://$ipAddress:8083/cinema/getAllRatingFeedback?filmId=$movieId';
      dynamic token = await Preferences().getTokenUsers();
      final responseFeedBack = await http.get(Uri.parse(url), headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      final result =
          jsonDecode(utf8.decode(responseFeedBack.body.runes.toList()));

      if (responseFeedBack.statusCode != 200 || result['code'] != 1000) {
        throw Exception(result['message']);
      }

      List<RatingFeedback> listFeedback = List<RatingFeedback>.from(
          result['result']
              .map((feedback) => RatingFeedback.fromjson(feedback)));

      return listFeedback;
    } catch (err) {
      throw Exception('Can\'t get all rating feedback: $err');

  static Future<RatingFeedback?> getRatingFeedback(BigInt orderId) async {
    final uri = 'http://$ipAddress:8083/cinema/getRatingFeedback?orderId=$orderId';
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
          return RatingFeedback.fromJson(result['result']);
        }
      }
      return null;
    } catch (err) {
      throw Exception(err);

    }
  }
}
