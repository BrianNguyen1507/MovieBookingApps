import 'package:flutter/material.dart';
import 'package:movie_booking_app/models/user/user.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/logout/logoutService.dart';
import 'package:movie_booking_app/services/Users/signIn/handleSignin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class ThemeProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isEnglish = true;
  final translator = GoogleTranslator();
  static const String _localePreferenceKey = 'localePreference';
  static const String _isEnglishPreferenceKey = 'isEnglishPreference';

  Locale get locale => _locale;
  bool get isEnglish => _isEnglish;

  String get languageDisplayText {
    return _locale.languageCode == 'en' ? 'English' : 'Vietnamese';
  }

  ThemeProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localeCode = prefs.getString(_localePreferenceKey);
    bool? isEnglish = prefs.getBool(_isEnglishPreferenceKey);

    if (localeCode != null) {
      _locale = Locale(localeCode);
    }

    if (isEnglish != null) {
      _isEnglish = isEnglish;
    }

    notifyListeners();
  }

  Future<void> _saveLocalePreference(String localeCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePreferenceKey, localeCode);
    await prefs.setBool(_isEnglishPreferenceKey, _isEnglish);
  }

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    _saveLocalePreference(newLocale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    if (_locale.languageCode == 'en' && _isEnglish) {
      setLocale(const Locale('vi'));
      _isEnglish = false;
    } else {
      setLocale(const Locale('en'));
      _isEnglish = true;
    }
    await _saveLocalePreference(_locale.languageCode);
    notifyListeners();
  }

  Future<String> translateText(String text) async {
    try {
      final translation = await translator.translate(
        text,
        from: _isEnglish ? 'vi' : 'en',
        to: _isEnglish ? 'en' : 'vi',
      );
      return translation.text;
    } catch (e) {
      throw Exception('Error translating text: $e');
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
