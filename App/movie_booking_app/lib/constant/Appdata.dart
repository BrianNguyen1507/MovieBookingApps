import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/AppConfig.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  static IconData questionMark = Icons.question_mark_sharp;
  static IconData star = Icons.star;
  static IconData playCircle = Icons.play_circle_outline_rounded;
}

class AppSize {
  static double width(context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(context) {
    return MediaQuery.of(context).size.height;
  }
}

class Appdata {
  static IconData? getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.storefront_rounded;
      case 1:
        return Icons.movie_creation_rounded;
      case 2:
        return Icons.person;

      default:
        return null;
    }
  }

  static String getReleased(context, bool isRelease) {
    return isRelease
        ? AppLocalizations.of(context)!.nowshowing
        : AppLocalizations.of(context)!.comming;
  }

  static String? getLabelForIndex(context, int index) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.store;
      case 1:
        return AppLocalizations.of(context)!.cinema;
      case 2:
        return AppLocalizations.of(context)!.personal;
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

  static String contentClassify(context, String type) {
    switch (type.toLowerCase()) {
      case 'k':
        return AppLocalizations.of(context)!.classify_K;
      case 'p':
        return AppLocalizations.of(context)!.classify_P;
      case 't13':
        return AppLocalizations.of(context)!.classify_T13;
      case 't16':
        return AppLocalizations.of(context)!.classify_T16;
      case 't18':
        return AppLocalizations.of(context)!.classify_T18;
      case 'c':
        return AppLocalizations.of(context)!.classify_K;
      default:
        return AppLocalizations.of(context)!.classify_K;
    }
  }
}

class RatingContent {
  static String contentRating(context, int rate) {
    switch (rate) {
      case 1:
        return AppLocalizations.of(context)!.rating_1;
      case 2:
        return AppLocalizations.of(context)!.rating_2;
      case 3:
        return AppLocalizations.of(context)!.rating_3;
      case 4:
        return AppLocalizations.of(context)!.rating_4;
      case 5:
        return AppLocalizations.of(context)!.rating_5;
      default:
        return AppLocalizations.of(context)!.rating_0;
    }
  }
}
