import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Future<void> saveSignInInfo(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<Map<String?, String?>?> saveAuthenticated(
      String auth, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? auth = prefs.getString('authenticated');
    return {'token': token, 'authenticated': auth};
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String?> getTokenUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
      return {'email': email, 'password': password};
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
