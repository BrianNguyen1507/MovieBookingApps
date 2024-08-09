import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/constant/app_data.dart';
import 'package:movie_booking_app/converter/converter.dart';
import 'package:movie_booking_app/models/movie/movie_detail.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/modules/timer/timer_display.dart';
import 'package:movie_booking_app/pages/order/components/movie_card.dart';
import 'package:movie_booking_app/pages/order/order_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movie_booking_app/pages/payments/components/payment_card.dart';
import 'package:movie_booking_app/pages/payments/handle-payments/handle_pay.dart';
import 'package:movie_booking_app/services/Users/movie-detail/movie_detail_service.dart';
import 'package:movie_booking_app/utils/common/widgets.dart';


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
      appBar: Common.customAppbar(
          context,
          TimmerWidget.timerDocked(context),
          AppStyle.headline2,
          AppLocalizations.of(context)!.pay_inf,
          AppColors.iconThemeColor,
          AppColors.appbarColor),
      body: SingleChildScrollView(
        child: Container(
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
                          style: AppStyle.headline3,
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
                    PaymentCard(
                      visible: widget.visible,
                      sumtotal: payAmount,
                      seats: widget.seats,
                      foods: widget.foods,
                      handlePayment: () => HandlePayment.zaloPayFuction(
                        context,
                        mounted,
                        widget.visible,
                        voucherId,
                        widget.seats,
                        widget.foods,
                        payAmount.toDouble(),
                        'ZALOPAY',
                      ),
                      methodName: 'ZALOPAY',
                      methodIcon: 'assets/images/ZaloPay-vuong.png',
                    ),
                    PaymentCard(
                      visible: widget.visible,
                      sumtotal: payAmount,
                      seats: widget.seats,
                      foods: widget.foods,
                      handlePayment: () => HandlePayment.vnPayFunction(
                        context,
                        mounted,
                        widget.visible,
                        voucherId,
                        'VNPAY',
                        widget.seats,
                        widget.foods,
                        payAmount.toDouble(),
                        'VNPAY',
                      ),
                      methodName: 'VNPAY',
                      methodIcon: 'assets/images/VNPAY-logo.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
