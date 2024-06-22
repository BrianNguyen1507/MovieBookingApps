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

class ClassifyColors {
  final String name;
  const ClassifyColors._internal(this.name);

  static const ClassifyColors red = ClassifyColors._internal('red');
  static const ClassifyColors green = ClassifyColors._internal('green');
  static const ClassifyColors blue = ClassifyColors._internal('blue');
  static const ClassifyColors yellow = ClassifyColors._internal('yellow');
  static const ClassifyColors orange = ClassifyColors._internal('orange');

  static ClassifyColors classifyType(String type) {
    switch (type.toLowerCase()) {
      case 'k':
        return ClassifyColors.blue;
      case 'p':
        return ClassifyColors.green;
      case 't13':
        return ClassifyColors.yellow;
      case 't16':
        return ClassifyColors.orange;
      case 't18':
      case 'c':
        return ClassifyColors.red;
      default:
        return ClassifyColors.blue;
    }
  }

  static Color toFlutterColor(ClassifyColors classifyColor) {
    switch (classifyColor.name) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return const Color.fromARGB(255, 218, 199, 31);
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
