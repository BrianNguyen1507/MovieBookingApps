import 'package:flutter/material.dart';

class AppColors {
  static const Color transpanrent = Colors.transparent;
  static Color opacityBlackColor = Colors.black.withOpacity(0.3);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color primaryColor = Color.fromARGB(255, 60, 161, 244);
  static const Color secondaryColor = Color.fromARGB(255, 152, 151, 151);
  static const Color commonColor = Color.fromARGB(255, 152, 151, 151);
  static const Color commonDarkColor = Color.fromARGB(255, 152, 151, 151);
  static const Color commonLightColor = Color(0xFFE8E8E8);
  static const Color textblackColor = Color(0xFF000000);
  static const Color darktextColor = Color(0xFF000000);
  static const Color lightTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color grayTextColor = Color.fromARGB(255, 79, 75, 75);
  static const Color bottomBgColor = Color(0xFFFFFFFF);
  static const Color buttonColor = Color(0xFF000000);
  static const Color appbarColor = Color(0xFF000000);
  static const Color titleTextColor = Color(0xFFFFFFFF);
  static const Color iconThemeColor = Color(0xFFFFFFFF);
  static const Color containerColor = Color(0xFFFFFFFF);
  static const Color snackbarConnection = Color.fromARGB(255, 69, 232, 61);
  static const Color snackbarLostConnection = Color.fromARGB(255, 255, 25, 25);
  static const Color shimmerColor = Color.fromARGB(255, 97, 97, 97);
  static const Color shimmerLightColor = Color.fromARGB(255, 117, 117, 117);
  static const Color correctColor = Color.fromARGB(255, 51, 122, 29);
  static const Color errorColor = Color.fromARGB(255, 235, 70, 70);
  static const Color shadowColor = Color.fromARGB(255, 151, 146, 146);

  static const Color seatAvailable = Color.fromARGB(255, 151, 146, 146);
  static const Color seatSold = Color.fromARGB(255, 241, 61, 61);
  static const Color seatPeding = Color.fromARGB(255, 225, 163, 8);
  static const Color seatDisable = Color.fromARGB(255, 68, 68, 68);
  static const Color textSeat = Color.fromARGB(255, 255, 255, 255);
  static const Color startRating = Colors.amber;
}

class AppFontSize {
  static const double superSmall = 10.0;
  static const double verySmall = 12.0;
  static const double small = 15.0;
  static const double lowMedium = 17.0;
  static const double medium = 20.0;
  static const double midMedium = 30.0;
  static const double midlarge = 35.0;
  static const double large = 40.0;
  static const double big = 50.0;
}

class ContainerRadius {
  static BorderRadius radius2 = const BorderRadius.all(
    Radius.circular(2),
  );
  static BorderRadius radius5 = const BorderRadius.all(
    Radius.circular(5),
  );
  static BorderRadius radius10 = const BorderRadius.all(
    Radius.circular(10),
  );
  static BorderRadius radius12 = const BorderRadius.all(
    Radius.circular(12),
  );
  static BorderRadius radius20 = const BorderRadius.all(
    Radius.circular(20),
  );
  static BorderRadius radius100 = const BorderRadius.all(
    Radius.circular(100),
  );
}

class AppStringMethod {
  static const String register = "register";
  static const String forgotPassword = "forgotPassword";
}

class AppPayments {
  static const String appName = "ZaloPay Flutter Demo";
  static const String version = "v2";
}
