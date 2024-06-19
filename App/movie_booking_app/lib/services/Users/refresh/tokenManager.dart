import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/services/Users/refresh/refreshService.dart';

class TokenManager {
  static const int _refreshMinutes = 60;
  static Timer? _refreshTimer;

  static void startTokenRefreshTimer(BuildContext context) {
    const refreshDuration = Duration(minutes: _refreshMinutes);
    _refreshTimer = Timer.periodic(refreshDuration, (timer) {
      RefreshToken.refreshToken();
    });
  }
  static void cancelTokenRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}
