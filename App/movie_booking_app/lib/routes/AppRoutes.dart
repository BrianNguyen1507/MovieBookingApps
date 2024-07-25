import 'package:flutter/material.dart';
import 'package:movie_booking_app/pages/home/homePage.dart';
import 'package:movie_booking_app/pages/index/index.dart';
import 'package:movie_booking_app/pages/ordered/listOrdered.dart';
import 'package:movie_booking_app/pages/profile/profile.dart';
import 'package:movie_booking_app/pages/sign-in-up/sign-in_sign-up.dart';
import 'package:movie_booking_app/pages/splash/SplashScreen.dart';
import 'package:movie_booking_app/pages/store/store.dart';

class AppRoutes {
  static const String splashScreen = '/splash_screen';
  static const String login = '/login';
  static const String homeScreen = '/home';
  static const String store = '/store';
  static const String profile = '/profile';
  static const String otp = '/otp';
  static const String listOrder = '/listOrder';
  static const String cinema = '/';
  static const String food = '/foods';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    homeScreen: (context) => const HomePage(),
    profile: (context) => const ProfilePage(),
    login: (context) => const SignInPage(),
    store: (context) => const StorePage(
          date: '',
          selection: false,
          movieId: -1,
          scheduleId: -1,
        ),
    listOrder: (context) => const ListOrdered(),
    cinema: (context) => const IndexPage(initialIndex: 1),
    food: (context) => const IndexPage(initialIndex: 0),
  };
}
