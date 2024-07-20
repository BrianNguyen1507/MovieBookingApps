import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_booking_app/constant/AppStyle.dart';
import 'package:movie_booking_app/constant/svgString.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/provider/sharedPreferences/prefs.dart';
import 'package:movie_booking_app/services/Users/order/createOrder/createOrderTickets.dart';
import 'package:movie_booking_app/services/Users/order/returnSeat/returnSeat.dart';

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
      BuildContext context,
      bool visible,
      String seat,
      int voucherId,
      String methodName,
      String appTranId,
      List<Map<String, dynamic>> foods,
      double total) async {
    //hien thi dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.string(
              svgSuccess,
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
    //call create luu order
    dynamic scheduleId = visible ? await Preferences().getSchedule() : -1;
    Set<String> seatFormat = ConverterUnit.convertStringToSet(seat);
    bool isReturn = false;
    if (seat.isNotEmpty) {
      isReturn = await ReturnSeatService.returnSeat(scheduleId, seatFormat);
    }
    if ((seat.isNotEmpty && isReturn) || seat.isEmpty) {
      CreateOrderService.createOrderTicket(
          scheduleId!, voucherId, methodName, appTranId, seat, foods, total);
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
            SvgPicture.string(
              svgError,
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
