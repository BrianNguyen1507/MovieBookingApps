import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/services/Users/order/create-order/create_order_service.dart';
import 'package:movie_booking_app/services/Users/order/return-seat/return_seat_service.dart';
import 'package:movie_booking_app/utils/dialog/show_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Handlepayments {
  static Future<Map<dynamic, dynamic>> handleZaloPay(
      String zpTransToken) async {
    const MethodChannel platform =
        MethodChannel('flutter.native/channelPayOrder');
    final Map<dynamic, dynamic> paymentResult =
        await platform.invokeMethod('payOrder', {"zptoken": zpTransToken});
    return paymentResult;
  }

  static handlePaymentSuccess(
      context,
      bool visible,
      String seat,
      int voucherId,
      String methodName,
      String appTranId,
      List<Map<String, dynamic>> foods,
      double total) async {
    debugPrint('THANH TOAN THANH CONG');

    dynamic scheduleId = visible ? await Preferences().getSchedule() : -1;
    Set<String> seatFormat = ConverterUnit.convertStringToSet(seat);
    bool isReturn = false;

    if (seat.isNotEmpty) {
      isReturn =
          await ReturnSeatService.returnSeat(context, scheduleId, seatFormat);
    }

    if ((seat.isNotEmpty && isReturn) || seat.isEmpty) {
      await CreateOrderService.createOrderTicket(context, scheduleId!,
          voucherId, methodName, appTranId, seat, foods, total);
      await Preferences().clearHoldSeats();

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/listOrder',
        ModalRoute.withName('/'),
      );
    }
  }

  static handlePaymentFail(context) {
    ShowDialog.showAlertCustom(context, AppLocalizations.of(context)!.payfail_noti,
        'Cancel', false, () {}, DialogType.error);
  }
}
