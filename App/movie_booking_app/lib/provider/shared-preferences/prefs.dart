import 'package:movie_booking_app/converter/converter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const String tokenKey = 'token';
  Future<void> saveSignInInfo(
      String email, String password, String name, String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('name', name);
    await prefs.setString('avatar', avatar);
  }

  Future<void> setAvatar(String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar', avatar);
  }

  Future<void> setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<void> saveAuthenticated(String auth, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString('authenticated', auth);
  }

  Future<void> saveTokenKey(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<String?> getAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('avatar');
  }

  Future<String?> getTokenUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
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

  Future<String?> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString('password');
    return password;
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('authenticated');
  }

  Future<void> removeSinginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('avatar');
  }

//save seat
  Future<void> saveHoldSeats(Set<String> seats) async {
    String getSeats = ConverterUnit.convertSetToString(seats);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('holdseat', getSeats);
  }

  Future<void> clearHoldSeats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('holdseat');
  }

  Future<String?> getHoldSeats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? holdSeat = prefs.getString('holdseat');
    return holdSeat;
  }

  //save schedule
  Future<void> saveSchedule(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('scheduleId', id);
  }

  Future<void> clearSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('scheduleId');
  }

  Future<int?> getSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('scheduleId');
  }

  //save Voucher
  Future<void> saveSVoucher(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('voucherId', id);
  }

  Future<void> clearVoucher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('voucherId');
  }

  Future<int?> getVoucher() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('voucherId');
  }
}
