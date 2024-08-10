import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResponseCode {
  final int code;
  final String message;

  const ResponseCode._(this.code, this.message);

  static ResponseCode nullException(context) {
    return ResponseCode._(8888, AppLocalizations.of(context)!.code_8888);
  }

  static ResponseCode uncategorizedException(context) {
    return ResponseCode._(9999, AppLocalizations.of(context)!.code_9999);
  }

  static ResponseCode invalidKey(context) {
    return ResponseCode._(1001, AppLocalizations.of(context)!.code_1001);
  }

  static ResponseCode unauthorized(context) {
    return ResponseCode._(1002, AppLocalizations.of(context)!.code_1002);
  }

  static ResponseCode invalidEmail(context) {
    return ResponseCode._(1003, AppLocalizations.of(context)!.code_1003);
  }

  static ResponseCode existsEmail(context) {
    return ResponseCode._(1004, AppLocalizations.of(context)!.code_1004);
  }

  static ResponseCode invalidPhone(context) {
    return ResponseCode._(1005, AppLocalizations.of(context)!.code_1005);
  }

  static ResponseCode invalidDob(context) {
    return ResponseCode._(1006, AppLocalizations.of(context)!.code_1006);
  }

  static ResponseCode accountInactive(context) {
    return ResponseCode._(1007, AppLocalizations.of(context)!.code_1007);
  }

  static ResponseCode expiredTimeOtp(context) {
    return ResponseCode._(1008, AppLocalizations.of(context)!.code_1008);
  }

  static ResponseCode emailPasswordIncorrect(context) {
    return ResponseCode._(1009, AppLocalizations.of(context)!.code_1009);
  }

  static ResponseCode incorrectOtp(context) {
    return ResponseCode._(1010, AppLocalizations.of(context)!.code_1010);
  }

  static ResponseCode passwordInvalid(context) {
    return ResponseCode._(1011, AppLocalizations.of(context)!.code_1011);
  }

  static ResponseCode categoryNotFound(context) {
    return ResponseCode._(1012, AppLocalizations.of(context)!.code_1012);
  }

  static ResponseCode filmNotFound(context) {
    return ResponseCode._(1013, AppLocalizations.of(context)!.code_1013);
  }

  static ResponseCode roomExists(context) {
    return ResponseCode._(1014, AppLocalizations.of(context)!.code_1014);
  }

  static ResponseCode categoryNameInvalid(context) {
    return ResponseCode._(1015, AppLocalizations.of(context)!.code_1015);
  }

  static ResponseCode stringIsEmpty(context) {
    return ResponseCode._(1016, AppLocalizations.of(context)!.code_1016);
  }

  static ResponseCode durationInvalid(context) {
    return ResponseCode._(1017, AppLocalizations.of(context)!.code_1017);
  }

  static ResponseCode unauthenticated(context) {
    return ResponseCode._(1018, AppLocalizations.of(context)!.code_1018);
  }

  static ResponseCode invalidDate(context) {
    return ResponseCode._(1019, AppLocalizations.of(context)!.code_1019);
  }

  static ResponseCode numberNotNegative(context) {
    return ResponseCode._(1020, AppLocalizations.of(context)!.code_1020);
  }

  static ResponseCode invalidPrice(context) {
    return ResponseCode._(1021, AppLocalizations.of(context)!.code_1021);
  }

  static ResponseCode notExistsEmail(context) {
    return ResponseCode._(1022, AppLocalizations.of(context)!.code_1022);
  }

  static ResponseCode categoryNameDuplicate(context) {
    return ResponseCode._(1023, AppLocalizations.of(context)!.code_1023);
  }

  static ResponseCode filmNameDuplicate(context) {
    return ResponseCode._(1024, AppLocalizations.of(context)!.code_1024);
  }

  static ResponseCode seatWasOrdered(context) {
    return ResponseCode._(1025, AppLocalizations.of(context)!.code_1025);
  }

  static ResponseCode voucherNotEnough(context) {
    return ResponseCode._(1026, AppLocalizations.of(context)!.code_1026);
  }

  static ResponseCode seatNotOrdered(context) {
    return ResponseCode._(1027, AppLocalizations.of(context)!.code_1027);
  }

  static ResponseCode accountNotExist(context) {
    return ResponseCode._(1028, AppLocalizations.of(context)!.code_1028);
  }

  static ResponseCode showtimeIsComingSoon(context) {
    return ResponseCode._(1029, AppLocalizations.of(context)!.code_1029);
  }

  static ResponseCode orderNotFound(context) {
    return ResponseCode._(1030, AppLocalizations.of(context)!.code_1030);
  }

  static ResponseCode foodNotFound(context) {
    return ResponseCode._(1031, AppLocalizations.of(context)!.code_1031);
  }

  static ResponseCode orderNotBelongAccount(context) {
    return ResponseCode._(1032, AppLocalizations.of(context)!.code_1032);
  }

  static ResponseCode cannotRating(context) {
    return ResponseCode._(1032, AppLocalizations.of(context)!.code_1032);
  }

  static ResponseCode wasRating(context) {
    return ResponseCode._(1033, AppLocalizations.of(context)!.code_1033);
  }

  static ResponseCode completeInformation(context) {
    return ResponseCode._(1034, AppLocalizations.of(context)!.code_1034);
  }

  static ResponseCode duplicatePassword(context) {
    return ResponseCode._(1035, AppLocalizations.of(context)!.code_1035);
  }

  static ResponseCode startTimeNotToday(context) {
    return ResponseCode._(1036, AppLocalizations.of(context)!.code_1036);
  }

  static ResponseCode roomNotFound(context) {
    return ResponseCode._(1037, AppLocalizations.of(context)!.code_1037);
  }

  static ResponseCode scheduleNotFound(context) {
    return ResponseCode._(1038, AppLocalizations.of(context)!.code_1038);
  }

  static ResponseCode filmNotRelease(context) {
    return ResponseCode._(1039, AppLocalizations.of(context)!.code_1039);
  }

  static ResponseCode dateAfterNow(context) {
    return ResponseCode._(1040, AppLocalizations.of(context)!.code_1040);
  }

  static ResponseCode orderCannotUsed(context) {
    return ResponseCode._(1041, AppLocalizations.of(context)!.code_1041);
  }

  static ResponseCode holdSeatAboveLimit(context) {
    return ResponseCode._(1042, AppLocalizations.of(context)!.code_1042);
  }

  static ResponseCode voucherNotFound(context) {
    return ResponseCode._(1043, AppLocalizations.of(context)!.code_1043);
  }

  static ResponseCode stringSeatIncorrect(context) {
    return ResponseCode._(1044, AppLocalizations.of(context)!.code_1044);
  }

  static ResponseCode? getMessage(int code, context) {
    switch (code) {
      case 8888:
        return nullException(context);
      case 9999:
        return uncategorizedException(context);
      case 1001:
        return invalidKey(context);
      case 1002:
        return unauthorized(context);
      case 1003:
        return invalidEmail(context);
      case 1004:
        return existsEmail(context);
      case 1005:
        return invalidPhone(context);
      case 1006:
        return invalidDob(context);
      case 1007:
        return accountInactive(context);
      case 1008:
        return expiredTimeOtp(context);
      case 1009:
        return emailPasswordIncorrect(context);
      case 1010:
        return incorrectOtp(context);
      case 1011:
        return passwordInvalid(context);
      case 1012:
        return categoryNotFound(context);
      case 1013:
        return filmNotFound(context);
      case 1014:
        return roomExists(context);
      case 1015:
        return categoryNameInvalid(context);
      case 1016:
        return stringIsEmpty(context);
      case 1017:
        return durationInvalid(context);
      case 1018:
        return unauthenticated(context);
      case 1019:
        return invalidDate(context);
      case 1020:
        return numberNotNegative(context);
      case 1021:
        return invalidPrice(context);
      case 1022:
        return notExistsEmail(context);
      case 1023:
        return categoryNameDuplicate(context);
      case 1024:
        return filmNameDuplicate(context);
      case 1025:
        return seatWasOrdered(context);
      case 1026:
        return voucherNotEnough(context);
      case 1027:
        return seatNotOrdered(context);
      case 1028:
        return accountNotExist(context);
      case 1029:
        return showtimeIsComingSoon(context);
      case 1030:
        return orderNotFound(context);
      case 1031:
        return foodNotFound(context);
      case 1032:
        return orderNotBelongAccount(context);
      case 1033:
        return wasRating(context);
      case 1034:
        return completeInformation(context);
      case 1035:
        return duplicatePassword(context);
      case 1036:
        return startTimeNotToday(context);
      case 1037:
        return roomNotFound(context);
      case 1038:
        return scheduleNotFound(context);
      case 1039:
        return filmNotRelease(context);
      case 1040:
        return dateAfterNow(context);
      case 1041:
        return orderCannotUsed(context);
      case 1042:
        return holdSeatAboveLimit(context);
      case 1043:
        return voucherNotFound(context);
      case 1044:
        return stringSeatIncorrect(context);
      default:
        return uncategorizedException(context);
    }
  }
}
