import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/provider/shared-preferences/prefs.dart';
import 'package:movie_booking_app/services/Users/order/create-order/create_order_service.dart';
import 'package:movie_booking_app/services/Users/order/return-seat/return_seat_service.dart';

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
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/success.svg',
              height: 100,
              width: 100,
            ),
            const Text(
              'Payment success',
              style: AppStyle.bodyText1,
            )
          ],
        ),
      ),
    );

    dynamic scheduleId = visible ? await Preferences().getSchedule() : -1;
    Set<String> seatFormat = ConverterUnit.convertStringToSet(seat);
    bool isReturn = false;
    if (seat.isNotEmpty) {
      isReturn =
          await ReturnSeatService.returnSeat(context, scheduleId, seatFormat);
    }
    if ((seat.isNotEmpty && isReturn) || seat.isEmpty) {
      CreateOrderService.createOrderTicket(context, scheduleId!, voucherId,
          methodName, appTranId, seat, foods, total);
      Preferences().clearHoldSeats();

      Future.delayed(
        const Duration(seconds: 3),
        () {
          return Navigator.pushNamedAndRemoveUntil(
            context,
            '/listOrder',
            ModalRoute.withName('/'),
          );
        },
      );
    }
  }

  static handlePaymentFail(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/fail.svg',
              height: 70,
              width: 70,
            ),
            const Text(
              'Payment Fail',
              style: AppStyle.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
