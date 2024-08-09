import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_booking_app/pages/payments/components/payment_view.dart';
import 'package:movie_booking_app/pages/payments/handle-payments/response_pay.dart';
import 'package:movie_booking_app/services/payments/vnpay/vnpay_response.dart';
import 'package:movie_booking_app/services/payments/vnpay/vnpay_service.dart';
import 'package:movie_booking_app/services/payments/zalopay/zalo_service.dart';

class HandlePayment {
  //ZALOPAY
  static Future<void> zaloPayFuction(
    context,
    bool mounted,
    bool visible,
    int voucherId,
    String seats,
    List<Map<String, dynamic>> foods,
    double sumTotal,
    String methodName,
  ) async {
    String response;
    String appTranId;

    //create order zalopay
    var createOrderResult = await createOrder(sumTotal.toInt());
    if (createOrderResult != null) {
      String zpTransToken = createOrderResult.zptranstoken;
      try {
        //call invoke apptoapp
        final Map<dynamic, dynamic> paymentResult =
            await PaymentResult.handleZaloPay(zpTransToken);

        response = paymentResult['result'].toString();

        appTranId = paymentResult['appTransID'] ?? '';

        if (response == 'Payment failed' || response == 'User Canceled') {
          PaymentResult.handlePaymentFail(context);
          return;
        }
        if (response == 'Payment Success') {
          return PaymentResult.handlePaymentSuccess(context, visible, seats,
              voucherId, methodName, appTranId, foods, sumTotal);
        }
      } on PlatformException catch (e) {
        response = 'Payment failed';
        debugPrint("PlatformException: ${e.message}");
      }
    }
  }

  //VNPAY
  static Future<void> vnPayFunction(
      context,
      bool mounted,
      bool visible,
      int voucherId,
      String payMethod,
      String seats,
      List<Map<String, dynamic>> foods,
      double sumTotal,
      String methodName) async {
    String urlpath;

    try {
      final VnPayResponse? result =
          await Vnpayservice.vnPayCreateOrder(sumTotal.toInt());
      urlpath = result!.url;

      final returnData = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebview(url: urlpath),
        ),
      );

      if (returnData != null) {
        String tranCode = returnData['transaction'];
        PaymentResult.handlePaymentSuccess(context, visible, seats, voucherId,
            methodName, tranCode, foods, sumTotal);
      } else {
        PaymentResult.handlePaymentFail(context);
      }
    } on PlatformException catch (e) {
      debugPrint("PlatformException: ${e.message}");
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }
}
