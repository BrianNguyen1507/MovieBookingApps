import 'package:flutter/material.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/logout/logoutService.dart';
import 'package:movie_booking_app/services/Users/signIn/handleSignin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  static const String _localePreferenceKey = 'localePreference';

  Locale get locale => _locale;

  String get languageDisplayText {
    return _locale.languageCode == 'en' ? 'English' : 'Vietnamese';
  }

  ThemeProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localeCode = prefs.getString(_localePreferenceKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
    }
    notifyListeners();
  }

  void _saveLocalePreference(String localeCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_localePreferenceKey, localeCode);
  }

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    _saveLocalePreference(newLocale.languageCode);
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      setLocale(const Locale('vi'));
    } else {
      setLocale(const Locale('en'));
    }
  }
}

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    notifyListeners();
    LogOutServices.logout();
    _user = null;
    notifyListeners();
  }

  Future<void> trySignIn(BuildContext context) async {
    Preferences preferences = Preferences();
    Map<String, String?>? loginInfo;
    try {
      loginInfo = await preferences.getSignInInfo();
    } catch (error) {
      print('Error getting sign-in info: $error');
      loginInfo = null;
    }

    if (loginInfo != null) {
      String? email = loginInfo['email'];
      String? password = loginInfo['password'];

      if (email != null && password != null) {
        HandleSigninState signinState = HandleSigninState();
        bool success;
        try {
          success = await signinState.validSignIn(context, email, password);
        } catch (error) {
          print('Error during sign-in: $error');
          success = false;
        }

        if (success) {
          _user = User(
              email: email,
              password: password,
              fullName: 'none',
              dayOfBirth: 'none',
              gender: 'none',
              phoneNumber: 'none');
          notifyListeners();
          return;
        } else {
          await preferences.clear();
        }
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const IndexPage(initialIndex: 1),
      ),
    );
  }
}
