import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';

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
  static IconData playButton = Icons.play_arrow_rounded;
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
        return Icons.storefront_rounded;
      case 3:
        return Icons.person;
      default:
        return null;
    }
  }

  static String getReleased(bool isRelease) {
    return isRelease ? 'Now Showing' : 'Coming Soon';
  }

  static String? getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Vouchers';
      case 1:
        return 'Cinema';
      case 2:
        return 'Store';
      case 3:
        return 'Personal';
      default:
        return null;
    }
  }
}

class SeatClass {
  static Color getSeatColor(int seatStatus) {
    switch (seatStatus) {
      case 0:
        return AppColors.seatAvailable.withOpacity(0.3);
      case 1:
        return AppColors.seatSold.withOpacity(0.6);

      case 2:
        return AppColors.seatPeding.withOpacity(0.6);
      case 3:
        return const Color.fromARGB(255, 214, 11, 255).withOpacity(0.6);

      default:
        return const Color.fromARGB(255, 214, 11, 255).withOpacity(0.6);
    }
  }
}

class ClassifyClass {
  final String name;
  const ClassifyClass._internal(this.name);

  static const ClassifyClass red = ClassifyClass._internal('red');
  static const ClassifyClass green = ClassifyClass._internal('green');
  static const ClassifyClass blue = ClassifyClass._internal('blue');
  static const ClassifyClass yellow = ClassifyClass._internal('yellow');
  static const ClassifyClass orange = ClassifyClass._internal('orange');

  static ClassifyClass classifyType(String type) {
    switch (type.toLowerCase()) {
      case 'k':
        return ClassifyClass.blue;
      case 'p':
        return ClassifyClass.green;
      case 't13':
        return ClassifyClass.yellow;
      case 't16':
        return ClassifyClass.orange;
      case 't18':
      case 'c':
        return ClassifyClass.red;
      default:
        return ClassifyClass.blue;
    }
  }

  static Color toFlutterColor(ClassifyClass classifyColor) {
    switch (classifyColor.name) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return const Color.fromARGB(255, 212, 195, 40);
      case 'orange':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  static String contentClassify(String type) {
    switch (type.toLowerCase()) {
      case 'k':
        return ('The movie is available for viewers under 13 years old with a guardian');
      case 'p':
        return ('The movie is available for viewers of all ages');
      case 't13':
        return ('The movie is available for viewers aged 13 and above');
      case 't16':
        return ('The movie is available for viewers aged 16 and above');
      case 't18':
        return ('The movie is available for viewers aged 18 and above');
      case 'c':
        return ('The movie is not allowed to be shown');
      default:
        return ('The movie is available for viewers of all ages');
    }
  }
}
