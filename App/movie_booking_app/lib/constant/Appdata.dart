import 'package:flutter/material.dart';

class AppIcon {
  static IconData watchedMovie = Icons.live_tv_rounded;
  static IconData reviews = Icons.reviews_rounded;
  static IconData wifioff = Icons.wifi_off_rounded;
  static IconData search = Icons.search;
  static IconData tickets = Icons.sticky_note_2_rounded;
  static IconData person = Icons.person;
  static IconData arrowR = Icons.keyboard_arrow_right;
  static IconData visibleOn = Icons.visibility;
  static IconData visibleOff = Icons.visibility_off;
  static IconData close = Icons.close;
}

class AppSize {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}

class Appdata {
  static IconData? getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.percent_rounded;
      case 1:
        return Icons.movie_creation_rounded;
      case 2:
        return Icons.home;
      case 3:
        return Icons.storefront_rounded;
      case 4:
        return Icons.person;
      default:
        return null;
    }
  }

  static String? getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Vouchers';
      case 1:
        return 'Home';
      case 2:
        return 'Cinema';
      case 3:
        return 'Store';
      case 4:
        return 'Personal';
      default:
        return null;
    }
  }
}
