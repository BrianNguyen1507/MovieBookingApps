import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/services/Users/refresh/refresh_service.dart';

class TokenManager {
  static const int _refreshMinutes = 50;
  static Timer? _refreshTimer;

  static void startTokenRefreshTimer(context) {
    debugPrint('Start refresh token');
    const refreshDuration = Duration(minutes: _refreshMinutes);
    _refreshTimer = Timer.periodic(refreshDuration, (timer) {
      RefreshToken.refreshToken(context);
    });
  }

  static void cancelTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
