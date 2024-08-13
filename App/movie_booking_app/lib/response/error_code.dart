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

  static final Map<int, Function> _responseCodeMap = {
    8888: nullException,
    9999: uncategorizedException,
    1001: invalidKey,
    1002: unauthorized,
    1003: invalidEmail,
    1004: existsEmail,
    1005: invalidPhone,
    1006: invalidDob,
    1007: accountInactive,
    1008: expiredTimeOtp,
    1009: emailPasswordIncorrect,
    1010: incorrectOtp,
    1011: passwordInvalid,
    1012: categoryNotFound,
    1013: filmNotFound,
    1014: roomExists,
    1015: categoryNameInvalid,
    1016: stringIsEmpty,
    1017: durationInvalid,
    1018: unauthenticated,
    1019: invalidDate,
    1020: numberNotNegative,
    1021: invalidPrice,
    1022: notExistsEmail,
    1023: categoryNameDuplicate,
    1024: filmNameDuplicate,
    1025: seatWasOrdered,
    1026: voucherNotEnough,
    1027: seatNotOrdered,
    1028: accountNotExist,
    1029: showtimeIsComingSoon,
    1030: orderNotFound,
    1031: foodNotFound,
    1032: orderNotBelongAccount,
    1033: wasRating,
    1034: completeInformation,
    1035: duplicatePassword,
    1036: startTimeNotToday,
    1037: roomNotFound,
    1038: scheduleNotFound,
    1039: filmNotRelease,
    1040: dateAfterNow,
    1041: orderCannotUsed,
    1042: holdSeatAboveLimit,
    1043: voucherNotFound,
    1044: stringSeatIncorrect,
  };

  static ResponseCode? getMessage(int code, context) {
    final responseFunction = _responseCodeMap[code];
    if (responseFunction != null) {
      return responseFunction(context);
    } else {
      return uncategorizedException(context);
    }
  }
}
