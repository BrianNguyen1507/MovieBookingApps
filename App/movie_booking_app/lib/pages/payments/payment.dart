import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie_detail.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/order/components/movie_card.dart';
import 'package:movie_booking_app/pages/order/order_page.dart';
import 'package:movie_booking_app/pages/payments/components/payment_view.dart';
import 'package:movie_booking_app/pages/payments/handle-payments/handle_pay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/services/Users/movie-detail/movie_detail_service.dart';
import 'package:movie_booking_app/services/Users/signup/valid_handle.dart';
import 'package:movie_booking_app/services/payments/vnpay/vnpay_response.dart';
import 'package:movie_booking_app/services/payments/vnpay/vnpay_service.dart';
import 'package:movie_booking_app/services/payments/zalopay/zalo_service.dart';

class PaymentPage extends StatefulWidget {
  final double sumtotal;
  final bool visible;
  final String seats;
  final List<Map<String, dynamic>> foods;
  final String theater;
  final int movieId;
  final String time;
  final String date;

  const PaymentPage({
    super.key,
    required this.sumtotal,
    required this.visible,
    required this.seats,
    required this.foods,
    required this.theater,
    required this.time,
    required this.date,
    required this.movieId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Future<MovieDetail?> movieData;

  String zpTransToken = "";
  String payResult = "";
  int payAmount = 0;

  @override
  void initState() {
    widget.visible
        ? movieData =
            MovieDetailService.deatailMovieService(context, widget.movieId)
        : null;

    payAmount = widget.sumtotal.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final numberSeats = ConverterUnit.convertStringToSet(widget.seats).length;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.pay_inf,
          style: AppStyle.headline2,
        ),
        iconTheme: const IconThemeData(color: AppColors.containerColor),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: AppSize.height(context),
          decoration: const BoxDecoration(
            color: AppColors.commonLightColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.visible
                  ? FutureBuilder(
                      future: movieData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        } else if (snapshot.hasError) {
                          return loadingContent;
                        } else {
                          final getMovie = snapshot.data!;
                          return movieCard(context, getMovie);
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  AppLocalizations.of(context)!.pay_inf,
                  style: AppStyle.bodyText1,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(15.0),
                width: AppSize.width(context),
                decoration: BoxDecoration(
                    color: AppColors.containerColor,
                    borderRadius: ContainerRadius.radius12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widget.visible
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${AppLocalizations.of(context)!.theater}:',
                                  style: AppStyle.bodyText1),
                              Text(widget.theater,
                                  style: AppStyle.paymentInfoText),
                            ],
                          )
                        : const SizedBox.shrink(),
                    widget.visible
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${AppLocalizations.of(context)!.show_time}:',
                                  style: AppStyle.bodyText1),
                              Text(
                                  '${ConverterUnit.formatToDmY(
                                    widget.visible
                                        ? widget.date
                                        : DateTime.now().toString(),
                                  )} | ${widget.time}',
                                  style: AppStyle.paymentInfoText),
                            ],
                          )
                        : const SizedBox.shrink(),
                    widget.visible
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${AppLocalizations.of(context)!.seats}:',
                                  style: AppStyle.bodyText1),
                              SizedBox(
                                width: numberSeats > 10
                                    ? AppSize.width(context) * 0.6
                                    : null,
                                child: Text(
                                  widget.seats,
                                  style: AppStyle.paymentInfoText,
                                ),
                              )
                            ],
                          )
                        : const SizedBox.shrink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppLocalizations.of(context)!.fnd}:',
                            style: AppStyle.bodyText1),
                        Text('x${widget.foods.length.toString()}',
                            style: AppStyle.paymentInfoText),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${AppLocalizations.of(context)!.sumtotal}:',
                            style: AppStyle.bodyText1),
                        Text(
                          '${ConverterUnit.formatPrice(widget.sumtotal)}₫',
                          style: AppStyle.headline1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  AppLocalizations.of(context)!.pay_method,
                  style: AppStyle.bodyText1,
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    paymentCardWidget(
                        widget.visible,
                        payAmount,
                        widget.seats,
                        widget.foods,
                        () => zaloPayFuction(widget.visible, widget.seats,
                            widget.foods, payAmount.toDouble(), 'ZALOPAY'),
                        'ZALOPAY',
                        'assets/images/ZaloPay-vuong.png'),
                    paymentCardWidget(
                        widget.visible,
                        payAmount,
                        widget.seats,
                        widget.foods,
                        () => vnPayFunction(
                              context,
                              widget.visible,
                              'VNPAY',
                              widget.seats,
                              widget.foods,
                              payAmount.toDouble(),
                              'VNPAY',
                            ),
                        'VNPAY',
                        'assets/images/VNPAY-logo.png'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentCardWidget(
    bool visible,
    int sumtotal,
    String? seats,
    List<Map<String, dynamic>> foods,
    Function handlePayment,
    String methodName,
    String methodIcon,
  ) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Tooltip(
        message: 'Payment via $methodName',
        child: GestureDetector(
          onTap: () async {
            int amount = sumtotal;
            if (amount < 1000 || amount > 1000000) {
              setState(() {
                zpTransToken = "Invalid Amount";
                ValidInput()
                    .showMessage(context, zpTransToken, AppColors.errorColor);
              });
            } else {
              if (mounted) {
                setState(() {
                  debugPrint('TONG TIEN LA: $sumtotal');
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      width: AppSize.width(context),
                      height: AppSize.height(context) * 0.2,
                      child: MaterialButton(
                        onPressed: () async {
                          await handlePayment();
                        },
                        child: Container(
                          height: AppSize.height(context) * 0.1,
                          width: AppSize.width(context),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: ContainerRadius.radius12,
                            color: AppColors.primaryColor,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${AppLocalizations.of(context)!.open} $methodName',
                              style: AppStyle.buttonText2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
              }
            }
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerColor,
                  borderRadius: ContainerRadius.radius12,
                ),
                margin: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: ContainerRadius.radius10,
                  child: Image.asset(
                    methodIcon,
                    height: 70,
                    width: 70,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Text(
                methodName,
                style: AppStyle.titleMovie,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> vnPayFunction(
      context,
      bool visible,
      String payMethod,
      String seats,
      List<Map<String, dynamic>> foods,
      double sumTotal,
      String methodName) async {
    String urlpath;

    try {
      final VnPayResponse result =
          await Vnpayservice.vnPayCreateOrder(sumTotal.toInt());
      urlpath = result.url;

      if (mounted) {
        final returnData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebview(url: urlpath),
          ),
        );

        if (returnData != null) {
          String tranCode = returnData['transaction'];
          Handlepayments.handlePaymentSuccess(context, visible, seats,
              voucherId, methodName, tranCode, foods, sumTotal);
        } else {
          Handlepayments.handlePaymentFail(context);
        }
      }
    } on PlatformException catch (e) {
      debugPrint("PlatformException: ${e.message}");
    } catch (e) {
      debugPrint("Exception: $e");
    }
  }

  Future<void> zaloPayFuction(
      bool visible,
      String seats,
      List<Map<String, dynamic>> foods,
      double sumTotal,
      String methodName) async {
    String response;
    String appTranId;

//create order zalopay
    var createOrderResult = await createOrder(sumTotal.toInt());

    if (createOrderResult != null) {
      zpTransToken = createOrderResult.zptranstoken;

      try {
//call invoke apptoapp
        final Map<dynamic, dynamic> paymentResult =
            await Handlepayments.handleZaloPay(zpTransToken);

        response = paymentResult['result'].toString();
        appTranId = paymentResult['appTransID'] ?? '';

        if (mounted) {
          if (response == 'Payment failed' || response == 'User Canceled') {
            Handlepayments.handlePaymentFail(context);
            return;
          }
          if (response == 'Payment Success') {
            return Handlepayments.handlePaymentSuccess(context, visible, seats,
                voucherId, methodName, appTranId, foods, sumTotal);
          }
        }
      } on PlatformException catch (e) {
        response = 'Payment failed';
        debugPrint("PlatformException: ${e.message}");
      }
    }
  }
}
