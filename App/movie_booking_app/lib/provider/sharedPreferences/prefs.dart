import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String TOKEN_KEY = 'token';
  Future<void> saveSignInInfo(
      String email, String password, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('name', name);
  }

  Future<void> saveAuthenticated(String auth, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString(TOKEN_KEY, token);
    await prefs.setString('authenticated', auth);
  }

  Future<void> saveTokenKey(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(TOKEN_KEY, token);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<String?> getTokenUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(TOKEN_KEY);
  }

  Future<bool> getAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? isAuth = prefs.getString('authenticated');
    if (token == null && isAuth == null) {
      return false;
    }
    return true;
  }

  Future<Map<String, String?>?> getSignInInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    String? password = prefs.getString('password');
    if (email != null && password != null) {
      return {
        'email': email,
        'password': password,
      };
    }
    return null;
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('token');
    await prefs.remove('authenticated');
  }
}
