import 'package:flutter/material.dart';
import 'package:movie_booking_app/constant/app_config.dart';
import 'package:movie_booking_app/constant/app_style.dart';
import 'package:movie_booking_app/models/ordered/order_detail.dart';
import 'package:movie_booking_app/models/ratingfeedback/rating_feedback.dart';
import 'package:movie_booking_app/modules/loading/loading.dart';
import 'package:movie_booking_app/pages/purchased-order/components/purchased_detail.dart';
import 'package:movie_booking_app/services/Users/puchased/detail_order.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({super.key, required this.id});
  final int id;
  @override
  State<StatefulWidget> createState() {
    return DetailOrderPageState();
  }
}

class DetailOrderPageState extends State<DetailOrderPage> {
  late Future<DetailOrder?> orderFuture;
  late RatingFeedback ratingFeedback;
  @override
  void initState() {
    super.initState();
    orderFuture = DetailOrderService.detailOrder(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detail_order),
        backgroundColor: AppColors.appbarColor,
        titleTextStyle: AppStyle.bannerText,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: AppColors.iconThemeColor,
        ),
      ),
      body: FutureBuilder<DetailOrder?>(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingData(context);
          } else if (!snapshot.hasData || snapshot.data == null) {
            return progressLoading;
          } else {
            DetailOrder order = snapshot.data!;
            return SingleChildScrollView(
                child: order.seat.isNotEmpty
                    ? detailOrderFilm(context, order)
                    : detailOrderFood(context, order));
          }
        },
      ),
    );
  }
}
